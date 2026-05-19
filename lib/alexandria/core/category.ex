defmodule Alexandria.Core.Category do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "alexandria_core_category"
    repo Alexandria.Repo

    references do
      reference :parent, name: "alexandria_core_category_parent_id_fkey", on_delete: :restrict
    end

    check_constraints do
      check_constraint :color,
        name: "alexandria_core_category_color_check",
        check: "color ~ '^#[0-9a-fA-F]{6}$'"
    end
  end

  actions do
    defaults [:read]

    read :list_roots do
      filter expr(is_nil(parent_id))
      prepare build(sort: [sort: :asc])
    end

    read :list_children do
      argument :parent_id, :string, allow_nil?: false
      filter expr(parent_id == ^arg(:parent_id))
      prepare build(sort: [sort: :asc])
    end

    create :create_root do
      accept [:slug, :name, :description, :color, :sort, :metainfo]
    end

    create :create_child do
      accept [:slug, :name, :description, :color, :sort, :metainfo]
      argument :parent_id, :string, allow_nil?: false
      change manage_relationship(:parent_id, :parent, type: :append)
    end

    update :rename do
      accept [:name, :description]
    end

    update :recolor do
      accept [:color]
    end

    update :reorder do
      accept [:sort]
    end

    update :set_metainfo do
      accept [:metainfo]
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  preparations do
    prepare build(load: [:display_name, :display_description])
  end

  attributes do
    attribute :slug, :string do
      primary_key? true
      allow_nil? false
      public? true
    end

    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :color, :string, allow_nil?: false, public?: true
    attribute :sort, :integer, default: 0, public?: true
    attribute :metainfo, :map, default: %{}, allow_nil?: false, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true

    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :parent, __MODULE__,
      attribute_type: :string,
      source_attribute: :parent_id,
      destination_attribute: :slug,
      public?: true

    has_many :children, __MODULE__,
      source_attribute: :slug,
      destination_attribute: :parent_id

    has_many :documents, Alexandria.Core.Document,
      source_attribute: :slug,
      destination_attribute: :category_id
  end

  calculations do
    calculate :display_name,
              :string,
              {Alexandria.Calculations.LocalizedField, attribute: :name},
              public?: true

    calculate :display_description,
              :string,
              {Alexandria.Calculations.LocalizedField, attribute: :description}
  end

  aggregates do
    count :active_document_count, :documents do
      filter expr(not archived?)
    end
  end
end
