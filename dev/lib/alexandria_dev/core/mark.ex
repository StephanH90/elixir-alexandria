defmodule AlexandriaDev.Core.Mark do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.Mark]

  postgres do
    table "marks"
    repo AlexandriaDev.Repo
  end

  alexandria_mark do
  end
end
