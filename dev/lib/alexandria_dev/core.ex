defmodule AlexandriaDev.Core do
  @moduledoc """
  Consumer-owned Ash domain proving the inverted Alexandria extension pattern.

  Resources here use `Alexandria.Core.Resource.*` extensions which inject
  attributes and relationships at compile time. Migrations, data layer,
  policies, and additional actions are owned by this app.
  """
  use Ash.Domain

  resources do
    resource AlexandriaDev.Core.Category
    resource AlexandriaDev.Core.Document
  end
end
