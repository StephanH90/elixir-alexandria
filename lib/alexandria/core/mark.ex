defmodule Alexandria.Core.Mark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_mark"
    repo Alexandria.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:id, :name, :description, :metainfo]
    end

    update :rename do
      accept [:name, :description]
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    attribute :id, :string do
      primary_key? true
      allow_nil? false
      public? true
      source :slug
    end

    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true

    create_timestamp :created_at
    update_timestamp :modified_at
  end
end
