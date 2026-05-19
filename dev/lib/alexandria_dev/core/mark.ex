defmodule AlexandriaDev.Core.Mark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.Mark]

  alexandria_mark do
  end
end
