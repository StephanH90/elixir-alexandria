defmodule Alexandria.Core.Resource.TagSynonymGroup do
  @moduledoc """
  Spark DSL extension that shapes a consumer-owned Ash resource into an
  Alexandria-compatible TagSynonymGroup.

  ## Usage

      defmodule MyApp.Core.TagSynonymGroup do
        use Ash.Resource,
          otp_app: :my_app,
          domain: MyApp.Core,
          data_layer: Ash.DataLayer.Ets,
          extensions: [Alexandria.Core.Resource.TagSynonymGroup]

        alexandria_tag_synonym_group do
          tag_resource MyApp.Core.Tag
        end
      end

  Injects `:id` (uuid PK), a required multilingual `:name`, a
  `has_many :tags` relationship pointed at the consumer's Tag resource,
  default `:read`/`:create`/`:rename` actions, and a locale-aware
  `display_name` calculation. The consumer owns the data layer, repo,
  policies, and any additional actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_tag_synonym_group,
    schema: [
      tag_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Tag resource to inverse-relate to (`has_many :tags`).",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.TagSynonymGroup.Transformer]
end
