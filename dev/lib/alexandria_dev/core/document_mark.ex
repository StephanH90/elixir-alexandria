defmodule AlexandriaDev.Core.DocumentMark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.DocumentMark]

  alexandria_document_mark do
    document_resource AlexandriaDev.Core.Document
    mark_resource AlexandriaDev.Core.Mark
  end
end
