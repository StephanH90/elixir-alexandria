defmodule AlexandriaDev.ExampleDomain do
  use Ash.Domain

  resources do
    resource(AlexandriaDev.Example)
  end
end
