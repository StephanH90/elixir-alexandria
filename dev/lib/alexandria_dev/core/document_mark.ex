defmodule AlexandriaDev.Core.DocumentMark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.DocumentMark]

  postgres do
    table "document_marks"
    repo AlexandriaDev.Repo
  end

  alexandria_document_mark do
    document_resource AlexandriaDev.Core.Document
    mark_resource AlexandriaDev.Core.Mark
  end
end
