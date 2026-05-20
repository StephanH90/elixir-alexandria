defmodule AlexandriaDev.Core.File do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.File]

  postgres do
    table "files"
    repo AlexandriaDev.Repo
  end

  alexandria_file do
    document_resource AlexandriaDev.Core.Document
  end
end
