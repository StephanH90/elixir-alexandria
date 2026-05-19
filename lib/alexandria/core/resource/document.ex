defmodule Alexandria.Core.Resource.Document do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible Document.

  ## Usage

      defmodule MyApp.Core.Document do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.Document]

        alexandria_document do
          category_resource MyApp.Core.Category
        end
      end

  Injects `:id` (uuid PK), `:title`, `:category_id`, `belongs_to :category`,
  and default `:read`/`:create`/`:update` actions. The consumer owns the data
  layer, repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_document,
    schema: [
      category_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Category resource to `belongs_to`.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.Document.Transformer]
end
