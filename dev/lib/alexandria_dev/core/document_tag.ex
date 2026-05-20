defmodule AlexandriaDev.Core.DocumentTag do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.DocumentTag]

  postgres do
    table "document_tags"
    repo AlexandriaDev.Repo
  end

  alexandria_document_tag do
    document_resource AlexandriaDev.Core.Document
    tag_resource AlexandriaDev.Core.Tag
  end
end
