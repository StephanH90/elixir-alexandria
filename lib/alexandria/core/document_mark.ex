defmodule Alexandria.Core.DocumentMark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_document_marks"
    repo Alexandria.Repo
  end

  actions do
    defaults [:read, :create, :destroy]
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id, public?: true
  end

  relationships do
    belongs_to :document, Alexandria.Core.Document, allow_nil?: false, public?: true

    belongs_to :mark, Alexandria.Core.Mark,
      attribute_type: :string,
      destination_attribute: :slug,
      allow_nil?: false,
      public?: true
  end
end
