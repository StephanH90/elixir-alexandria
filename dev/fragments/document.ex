defmodule AlexandriaDev.Fragments.Document do
  use Spark.Dsl.Fragment, of: Ash.Resource, authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  actions do
    read :foobar do
      filter expr(not archived?)
    end
  end
end
