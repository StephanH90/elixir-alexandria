defmodule Alexandria.Core.File do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_file"
    repo Alexandria.Repo

    check_constraints do
      check_constraint :variant,
        name: "alexandria_core_file_variant_check",
        check: "variant IN ('original', 'thumbnail', 'rendering')"
    end
  end

  actions do
    defaults [:read]

    read :for_document do
      argument :document_id, :uuid, allow_nil?: false
      filter expr(document_id == ^arg(:document_id))
    end

    create :upload_original do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change set_attribute(:variant, :original)
      change Alexandria.Core.File.Changes.PutBytes
    end

    create :upload_thumbnail do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :original_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change manage_relationship(:original_id, :original, type: :append)
      change set_attribute(:variant, :thumbnail)
      change Alexandria.Core.File.Changes.PutBytes
    end

    create :upload_rendering do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :original_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change manage_relationship(:original_id, :original, type: :append)
      change set_attribute(:variant, :rendering)
      change Alexandria.Core.File.Changes.PutBytes
    end

    update :rename do
      accept [:name]
    end

    update :replace_content do
      accept [:mime_type, :size]
      argument :bytes, :string, allow_nil?: false
      require_atomic? false
      change Alexandria.Core.File.Changes.ReplaceBytes
    end

    destroy :destroy do
      require_atomic? false
      change Alexandria.Core.File.Changes.DeleteFromStorage
    end

    action :download_url, :string do
      argument :id, :uuid, allow_nil?: false

      run fn input, _ctx ->
        case Ash.get(__MODULE__, input.arguments.id) do
          {:ok, %{content: key}} -> Alexandria.Storage.presigned_url(key)
          {:error, _} = e -> e
        end
      end
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id, public?: true
    attribute :name, :string, allow_nil?: false, public?: true

    attribute :variant, :atom,
      constraints: [one_of: [:original, :thumbnail, :rendering]],
      default: :original,
      allow_nil?: false,
      public?: true

    attribute :content, :string, allow_nil?: false, public?: true
    attribute :mime_type, :string, allow_nil?: false, public?: true
    attribute :size, :integer, allow_nil?: false, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :document, Alexandria.Core.Document, allow_nil?: false, public?: true
    belongs_to :original, __MODULE__, public?: true
  end
end
