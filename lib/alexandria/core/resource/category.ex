defmodule Alexandria.Core.Resource.Category do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible Category.

  ## Usage

      defmodule MyApp.Core.Category do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.Category]

        alexandria_category do
          document_resource MyApp.Core.Document
        end
      end

  The consumer owns the data layer, repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_category,
    schema: [
      document_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Document resource to inverse-relate to (`has_many :documents`).",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.Category.Transformer]
end
