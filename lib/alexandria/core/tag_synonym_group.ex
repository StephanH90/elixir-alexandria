defmodule Alexandria.Core.TagSynonymGroup do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "alexandria_core_tagsynonymgroup"
    repo Alexandria.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name]
    end

    update :rename do
      accept [:name]
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
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
  end

  relationships do
    has_many :tags, Alexandria.Core.Tag, destination_attribute: :tag_synonym_group_id
  end

  calculations do
    calculate :display_name,
              :string,
              {Alexandria.Calculations.LocalizedField, attribute: :name}
  end
end
