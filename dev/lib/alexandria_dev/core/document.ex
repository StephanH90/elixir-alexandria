defmodule AlexandriaDev.Core.Document do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.Document]

  alexandria_document do
    category_resource AlexandriaDev.Core.Category
  end
end
