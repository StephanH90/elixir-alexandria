defmodule Alexandria.Core.Resource.DocumentMark do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible DocumentMark join resource.

  ## Usage

      defmodule MyApp.Core.DocumentMark do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.DocumentMark]

        alexandria_document_mark do
          document_resource MyApp.Core.Document
          mark_resource MyApp.Core.Mark
        end
      end

  Injects `:id` (uuid PK), `belongs_to :document`, `belongs_to :mark`, and
  default `:read`/`:create` actions. The consumer owns the data layer,
  repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_document_mark,
    schema: [
      document_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Document resource to `belongs_to`.",
        required: true
      ],
      mark_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Mark resource to `belongs_to`.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.DocumentMark.Transformer]
end
