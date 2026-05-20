defmodule AlexandriaDev.Core.Document do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.Document]

  postgres do
    table "documents"
    repo AlexandriaDev.Repo
  end

  alexandria_document do
    category_resource AlexandriaDev.Core.Category
    tag_resource AlexandriaDev.Core.Tag
    mark_resource AlexandriaDev.Core.Mark
    file_resource AlexandriaDev.Core.File
    document_tag_resource AlexandriaDev.Core.DocumentTag
    document_mark_resource AlexandriaDev.Core.DocumentMark
  end
end
