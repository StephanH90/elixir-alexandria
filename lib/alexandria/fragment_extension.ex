defmodule Alexandria.FragmentExtension do
  @moduledoc """
  Spark DSL extension that lets a consumer application extend Alexandria's
  Ash resources and the `Alexandria.Core` domain at compile time, without
  forking this library.

  ## Why

  Alexandria ships a fixed set of resources (`Document`, `Category`, `File`,
  `Tag`, `Mark`, …) with generic actions and no per-tenant policies. Real
  consumers (e.g. `elixir-ebau`) need to bolt on:

    * canton-specific policies (`Ash.Policy.Authorizer` rules)
    * extra read/update actions scoped to their own domain concepts
    * calculations, aggregates, validations, preparations, changes
    * non-persisted relationships into the consumer's own resources

  This extension wires `Spark.Dsl.Fragment` modules — supplied by the
  consumer via application config — into each host resource/domain at
  compile time.

  ## How it works

  Every resource (and the `Alexandria.Core` domain) lists this extension:

      use Ash.Resource,
        otp_app: :alexandria,
        extensions: [Alexandria.FragmentExtension]

  The transformer (`Alexandria.FragmentExtension.Transformer`) reads
  application config keyed by the host module and feeds the fragment list
  to `Spark.Dsl.handle_fragments/2`. Spark merges each fragment's DSL into
  the host's DSL state, so the resulting compiled module exposes both the
  library-defined and consumer-defined sections as if they were written in
  one file.

  Lookup is `Application.get_env(otp_app, host_module)[:fragments]`.
  Missing config → zero fragments → host compiles unchanged.

  ## Consumer usage

  Register fragments per host module in the consumer's `config/config.exs`
  **before** the host module is compiled (i.e. at normal config-time —
  *not* `runtime.exs`):

      config :alexandria, Alexandria.Core.Document,
        fragments: [Ebau.Alexandria.DocumentInstancePolicies,
                    Ebau.Alexandria.DocumentInstanceActions]

      config :alexandria, Alexandria.Core.Category,
        fragments: [Ebau.Alexandria.CategoryVisibilities]

      config :alexandria, Alexandria.Core,
        fragments: [Ebau.Alexandria.DomainCrossActions]

  A fragment is a plain `Spark.Dsl.Fragment` module targeting `Ash.Resource`
  (or `Ash.Domain` for domain fragments):

      defmodule Ebau.Alexandria.DocumentInstanceFragment do
        use Spark.Dsl.Fragment, of: Ash.Resource

        actions do
          read :for_instance do
            argument :instance_id, :integer, allow_nil?: false
            filter expr(fragment_data["instance_id"] == ^arg(:instance_id))
          end
        end
      end

  ## What fragments may and may not do

  Allowed:

    * add `actions`, `calculations`, `aggregates`, `validations`,
      `preparations`, `changes`
    * add `policies` (AND-merged with the host's base policies)
    * add non-persisted `relationships` pointing into the consumer's domain

  Not allowed:

    * add persisted attributes
    * change `table`, `repo`, or `identities`
    * alter `data_layer:` or `authorizers:`

  Consumer-owned persisted state belongs in the existing `metainfo` JSONB
  column or in a sidecar resource in the consumer's own domain.

  ## Compile-time only

  Fragments are resolved when the host module compiles. Adding or removing
  a fragment requires a recompile of the host (`mix deps.compile alexandria
  --force` when changing config in the consumer app).

  ## Where the fragment source lives

  Mix compiles deps strictly before the parent app, so a fragment module
  written in the consumer's own `lib/` would not exist yet when
  `:alexandria` compiles. To avoid that chicken-and-egg, the consumer
  injects a source directory into Alexandria's compile via the
  `:extra_elixirc_paths` knob (see `Alexandria.MixProject`):

      # In consumer's config/config.exs
      config :alexandria, :extra_elixirc_paths, [
        Path.expand("../fragments", __DIR__)
      ]

      config :alexandria, Alexandria.Core.Document,
        fragments: [MyApp.Fragments.Document]

  The fragment file lives outside the consumer's own `elixirc_paths`
  (e.g. in `fragments/` next to `lib/`) so it is not compiled twice.
  Alexandria pulls it in, compiles it as part of its own build, and the
  transformer finds the module on the code path when it runs.

  ## Missing fragments are skipped

  If a fragment module listed in config is still not loaded when the
  host compiles (e.g. a misconfigured consumer), the transformer logs a
  warning and skips it instead of crashing.
  """
  use Spark.Dsl.Extension,
    transformers: [Alexandria.FragmentExtension.Transformer]
end
