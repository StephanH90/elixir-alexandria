defmodule AlexandriaDev.Core.DocumentTag do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.DocumentTag]

  alexandria_document_tag do
    document_resource AlexandriaDev.Core.Document
    tag_resource AlexandriaDev.Core.Tag
  end
end
