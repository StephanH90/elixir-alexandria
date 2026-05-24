import Config

config :alexandria, Alexandria.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2,
  database: "alexandria_dev_test#{System.get_env("MIX_TEST_PARTITION")}"

config :alexandria, :storage, adapter: AlexandriaDev.Test.InMemoryStorage

config :alexandria_dev, AlexandriaDevWeb.Endpoint, server: false

config :phoenix_test, endpoint: AlexandriaDevWeb.Endpoint
