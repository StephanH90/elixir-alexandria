defmodule AlexandriaDev.Core.File do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.File]

  alexandria_file do
    document_resource AlexandriaDev.Core.Document
  end
end
