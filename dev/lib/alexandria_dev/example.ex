defmodule AlexandriaDev.Example do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: AlexandriaDev.ExampleDomain

  attributes do
    uuid_primary_key :id
  end

  actions do
    defaults [:read, :destroy, update: :*, create: :*]
  end
end
