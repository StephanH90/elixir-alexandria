defmodule Alexandria.Core.Document do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_document"
    repo Alexandria.Repo
  end

  actions do
    defaults [:read]

    read :list_by_category do
      argument :category_id, :string, allow_nil?: false
      filter expr(category_id == ^arg(:category_id))
    end

    read :by_tag do
      argument :tag_id, :string, allow_nil?: false
      filter expr(exists(tags, slug == ^arg(:tag_id)))
    end

    read :by_mark do
      argument :mark_id, :string, allow_nil?: false
      filter expr(exists(marks, slug == ^arg(:mark_id)))
    end

    read :list_by_ids do
      argument :ids, {:array, :uuid}, allow_nil?: false
      filter expr(id in ^arg(:ids))
    end

    create :create do
      accept [:title, :description, :date, :metainfo]
      argument :category_id, :string, allow_nil?: false
      change manage_relationship(:category_id, :category, type: :append)
    end

    create :upload do
      accept [:title, :description, :date, :metainfo]
      argument :category_id, :string, allow_nil?: false
      argument :file_name, :string, allow_nil?: false
      argument :mime_type, :string, allow_nil?: false
      argument :size, :integer, allow_nil?: false
      argument :bytes, :string, allow_nil?: false

      change manage_relationship(:category_id, :category, type: :append)

      change after_action(fn changeset, document, context ->
               {:ok, _file} =
                 Alexandria.Core.upload_original_file(
                   %{
                     name: Ash.Changeset.get_argument(changeset, :file_name),
                     mime_type: Ash.Changeset.get_argument(changeset, :mime_type),
                     size: Ash.Changeset.get_argument(changeset, :size),
                     document_id: document.id,
                     bytes: Ash.Changeset.get_argument(changeset, :bytes)
                   },
                   actor: context.actor
                 )

               {:ok, document}
             end)
    end

    update :rename do
      accept [:title]
    end

    update :edit_description do
      accept [:description]
    end

    update :set_date do
      accept [:date]
    end

    update :move_to_category do
      accept []
      argument :category_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:category_id, :category, type: :append_and_remove)
    end

    update :set_metainfo do
      accept [:metainfo]
    end

    update :add_tag do
      accept []
      argument :tag_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:tag_id, :tags, type: :append, on_no_match: :error)
    end

    update :remove_tag do
      accept []
      argument :tag_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:tag_id, :tags, type: :remove)
    end

    update :add_mark do
      accept []
      argument :mark_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:mark_id, :marks, type: :append, on_no_match: :error)
    end

    update :remove_mark do
      accept []
      argument :mark_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:mark_id, :marks, type: :remove)
    end

    update :archive do
      accept []
      require_atomic? false
      change {Alexandria.Core.Document.Changes.ToggleArchived, flag: :on}
    end

    update :restore do
      accept []
      require_atomic? false
      change {Alexandria.Core.Document.Changes.ToggleArchived, flag: :off}
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id, public?: true
    attribute :title, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :date, :date, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :category, Alexandria.Core.Category,
      attribute_type: :string,
      destination_attribute: :slug,
      allow_nil?: false,
      public?: true

    many_to_many :tags, Alexandria.Core.Tag,
      through: Alexandria.Core.DocumentTag,
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :tag_id,
      destination_attribute: :slug

    many_to_many :marks, Alexandria.Core.Mark,
      through: Alexandria.Core.DocumentMark,
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :mark_id,
      destination_attribute: :slug

    has_many :files, Alexandria.Core.File
  end
end
