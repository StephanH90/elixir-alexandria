import Config

config :alexandria, Alexandria.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :alexandria, :storage, adapter: Alexandria.Storage.InMemory

config :alexandria_dev, AlexandriaDevWeb.Endpoint, server: false

config :phoenix_test, endpoint: AlexandriaDevWeb.Endpoint
