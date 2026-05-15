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

  def transform(dsl_state) do
    module = DslTransformer.get_persisted(dsl_state, :module)
    otp_app = DslTransformer.get_persisted(dsl_state, :otp_app)

    fragments =
      case otp_app && Application.get_env(otp_app, module) do
        nil -> []
        config -> Keyword.get(config, :fragments, [])
      end

    fragments = available(fragments, module)
    register_external_resources(module, fragments)

    {:ok, Spark.Dsl.handle_fragments(dsl_state, fragments)}
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
