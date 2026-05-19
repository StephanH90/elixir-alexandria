defmodule Alexandria.Core.Resource.Mark do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible Mark.

  ## Usage

      defmodule MyApp.Core.Mark do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.Mark]

        alexandria_mark do
        end
      end

  Injects `:slug` (string PK), multilingual `:name` and `:description`,
  `:metainfo`, `:created_by_user`, `:created_by_group`, timestamps, the
  default `:read`/`:create`/`:rename` actions, and locale-aware
  `display_name`/`display_description` calculations. The consumer owns
  the data layer, repo, policies, and any additional actions.

  Mark has no relationships, so the `alexandria_mark` section is empty
  but is kept for API symmetry with the other Alexandria resource
  extensions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_mark,
    schema: []
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.Mark.Transformer]
end
