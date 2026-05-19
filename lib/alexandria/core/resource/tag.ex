defmodule Alexandria.Core.Resource.Tag do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible Tag.

  ## Usage

      defmodule MyApp.Core.Tag do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.Tag]

        alexandria_tag do
          tag_synonym_group_resource MyApp.Core.TagSynonymGroup
        end
      end

  Injects `:slug` (string PK), localized `:name`/`:description`, metainfo,
  audit attributes, timestamps, `belongs_to :tag_synonym_group`, default
  `:read`/`:create`/`:rename`/`:join_synonym_group`/`:leave_synonym_group`
  actions, and `:display_name`/`:display_description` calculations.

  The consumer owns the data layer, repo, policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_tag,
    schema: [
      tag_synonym_group_resource: [
        type: {:spark, Ash.Resource},
        doc: "The TagSynonymGroup resource to `belongs_to`.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.Tag.Transformer]
end
