defmodule Alexandria.Core.Resource.DocumentTag do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible DocumentTag join resource.

  ## Usage

      defmodule MyApp.Core.DocumentTag do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.DocumentTag]

        alexandria_document_tag do
          document_resource MyApp.Core.Document
          tag_resource MyApp.Core.Tag
        end
      end

  Injects `:id` (uuid PK), `belongs_to :document`, `belongs_to :tag`, and
  default `:read`/`:create` actions. The consumer owns the data layer,
  repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_document_tag,
    schema: [
      document_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Document resource to `belongs_to`.",
        required: true
      ],
      tag_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Tag resource to `belongs_to`.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.DocumentTag.Transformer]
end
