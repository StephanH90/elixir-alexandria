defmodule AlexandriaDev.Fragments.Document do
  use Spark.Dsl.Fragment, of: Ash.Resource, authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  calculations do
    calculate :created_by_username, :string, "foobar"
  end

  preparations do
    prepare build(load: :created_by_username)
  end
end
