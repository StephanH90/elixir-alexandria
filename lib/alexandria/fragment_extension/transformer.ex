defmodule Alexandria.FragmentExtension.Transformer do
  @moduledoc """
  Spark transformer that reads the host module's fragment list from
  application config and merges those fragments into the DSL state.

  Config shape:

      config :<otp_app>, <HostModule>, fragments: [FragA, FragB]

  The host module's `otp_app` is read from the persisted DSL state, so
  the transformer is reusable across any app that mounts this extension.
  See `Alexandria.FragmentExtension` for the consumer-facing docs.
  """
  use Spark.Dsl.Transformer

  require Logger

  alias Spark.Dsl.Transformer, as: DslTransformer

  # Fragment merging must happen before every other resource transformer.
  # Several built-in Ash transformers (e.g. `SetRelationshipSource`,
  # `CacheRelationships`, `BelongsToAttribute`, ...) walk the DSL state and
  # mutate entities (set `:source`, derive join attrs, etc). If they run
  # before our merge, fragment-added entities miss those passes — most
  # visibly, a fragment-added `has_one` ends up with `source: nil` and
  # blows up at load time inside `Ash.DataLayer.data_layer_can?/2`.
  def before?(_), do: true

  def transform(dsl_state) do
    module = DslTransformer.get_persisted(dsl_state, :module)
    otp_app = DslTransformer.get_persisted(dsl_state, :otp_app)

    fragments =
      case otp_app && Application.get_env(otp_app, module) do
        nil -> []
        config -> Keyword.get(config, :fragments, [])
      end

    fragments = available(fragments, module)
    Enum.each(fragments, &reject_attributes!(&1, module))
    register_external_resources(module, fragments)

    {:ok, Spark.Dsl.handle_fragments(dsl_state, fragments)}
  end

  # Fragments may not introduce attributes. The consumer's app does not own
  # this resource's table or migrations, so a fragment-added attribute would
  # appear in generated SQL with no backing column. Steer consumers to
  # `metainfo` JSONB, a sidecar resource in their own domain, or a
  # calculation/aggregate.
  defp reject_attributes!(frag, host) do
    entities =
      frag.spark_dsl_config()
      |> Map.get([:attributes], %{})
      |> Map.get(:entities, [])

    case Enum.map(entities, & &1.name) do
      [] ->
        :ok

      names ->
        raise Spark.Error.DslError,
          module: frag,
          path: [:attributes],
          message: """
          Fragment #{inspect(frag)} for #{inspect(host)} declares \
          attribute(s) #{inspect(names)}. Fragments may not add attributes \
          to host resources — the consumer does not own #{inspect(host)}'s \
          table or migrations.

          Alternatives:
            * store consumer-owned data in the existing `metainfo` JSONB \
              column (read via a `calculate` using `fragment/2`, write via \
              an update action that merges into `metainfo`)
            * create a sidecar resource in the consumer's own domain with a \
              `belongs_to` back to #{inspect(host)}
            * if the value is derived, use a `calculate` or `aggregate`
          """
    end
  end

  # Register each fragment's source file as an `@external_resource` of
  # the host module so mix's incremental compiler invalidates the host
  # beam whenever a fragment file changes. Without this, editing a
  # fragment recompiles only the fragment, leaving the host with stale
  # baked-in DSL.
  defp register_external_resources(host, fragments) do
    for frag <- fragments,
        src = frag.module_info(:compile)[:source],
        src != nil do
      Module.put_attribute(host, :external_resource, to_string(src))
    end
  end

  defp available(fragments, host) do
    Enum.filter(fragments, fn frag ->
      case Code.ensure_compiled(frag) do
        {:module, _} ->
          true

        {:error, reason} ->
          Logger.warning(
            "Alexandria.FragmentExtension: fragment #{inspect(frag)} for " <>
              "#{inspect(host)} is not loaded (#{inspect(reason)}); skipping. " <>
              "Recompile #{inspect(host)} after the fragment module is " <>
              "available to wire it in."
          )

          false
      end
    end)
  end
end
