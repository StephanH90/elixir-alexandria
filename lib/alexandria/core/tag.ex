defmodule Alexandria.Core.Tag do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "alexandria_core_tag"
    repo Alexandria.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:slug, :name, :description, :metainfo]
    end

    update :rename do
      accept [:name, :description]
    end

    update :join_synonym_group do
      accept []
      require_atomic? false
      argument :group_id, :uuid, allow_nil?: false
      change manage_relationship(:group_id, :tag_synonym_group, type: :append_and_remove)
    end

    update :leave_synonym_group do
      accept []
      change set_attribute(:tag_synonym_group_id, nil)
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    attribute :slug, :string do
      primary_key? true
      allow_nil? false
      public? true
    end

    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true

    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :tag_synonym_group, Alexandria.Core.TagSynonymGroup, public?: true
  end

  calculations do
    calculate :display_name,
              :string,
              {Alexandria.Calculations.LocalizedField, attribute: :name}

    calculate :display_description,
              :string,
              {Alexandria.Calculations.LocalizedField, attribute: :description}
  end
end
