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
          tag_resource MyApp.Core.Tag
          mark_resource MyApp.Core.Mark
          file_resource MyApp.Core.File
          document_tag_resource MyApp.Core.DocumentTag
          document_mark_resource MyApp.Core.DocumentMark
        end
      end

  Injects the canonical Alexandria Document shape: `:id`, multilingual
  `:title`/`:description`, `:date`, `:metainfo`, audit columns,
  timestamps, `belongs_to :category`, `many_to_many :tags`,
  `many_to_many :marks`, `has_many :files`, the full action surface
  (read filters, create, upload, rename, edit_description, set_date,
  move_to_category, set_metainfo, add/remove_tag, add/remove_mark,
  archive, restore, update_title_description_date), the
  `display_title` / `display_description` / `archived?` calculations,
  and the `tags_slugs` aggregate.

  `destroy` actions are intentionally NOT injected so the extension can
  be used with data layers that do not support destroy (e.g. Ets). The
  consumer owns the data layer, repo, policies, and any additional
  actions.
  """
  @section %Spark.Dsl.Section{
    name: :alexandria_document,
    schema: [
      category_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Category resource to `belongs_to`.",
        required: true
      ],
      tag_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Tag resource for the `many_to_many :tags` destination.",
        required: true
      ],
      mark_resource: [
        type: {:spark, Ash.Resource},
        doc: "The Mark resource for the `many_to_many :marks` destination.",
        required: true
      ],
      file_resource: [
        type: {:spark, Ash.Resource},
        doc: "The File resource for `has_many :files`.",
        required: true
      ],
      document_tag_resource: [
        type: {:spark, Ash.Resource},
        doc: "The join resource that links documents and tags.",
        required: true
      ],
      document_mark_resource: [
        type: {:spark, Ash.Resource},
        doc: "The join resource that links documents and marks.",
        required: true
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@section],
    transformers: [Alexandria.Core.Resource.Document.Transformer]
end
