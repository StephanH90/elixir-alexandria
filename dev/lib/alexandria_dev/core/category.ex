defmodule AlexandriaDev.Core.Category do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.Category]

  postgres do
    table "categories"
    repo AlexandriaDev.Repo
  end

  alexandria_category do
    document_resource AlexandriaDev.Core.Document
  end
end
