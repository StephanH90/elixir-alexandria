defmodule Alexandria.Core.Resource.File do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible File.

  ## Usage

      defmodule MyApp.Core.File do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.File]

        alexandria_file do
          document_resource MyApp.Core.Document
        end
      end

  Injects attributes (`:id`, `:name`, `:variant`, `:content`, `:mime_type`,
  `:size`, `:checksum`, `:metainfo`, `:created_by_user`, `:created_by_group`,
  timestamps), relationships (`belongs_to :document`, self `belongs_to :original`),
  upload/rename/replace/download actions, and the `:display_size` calculation.

  The consumer owns the data layer, repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_file,
    schema: [
      document_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Document resource that files `belongs_to`.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.File.Transformer]
end
