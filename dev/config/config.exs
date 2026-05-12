import Config

# Inherit Alexandria.Repo connection from the parent's config; override DB only if needed.
config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "alexandria_dev",
  pool_size: 10

config :alexandria,
  ash_domains: [Alexandria.Core],
  ecto_repos: [Alexandria.Repo]

config :alexandria_dev, ecto_repos: [Alexandria.Repo]

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  url: [host: "localhost"],
  secret_key_base: String.duplicate("a", 64),
  live_view: [signing_salt: "alexandria-dev-salt"],
  pubsub_server: AlexandriaDev.PubSub,
  render_errors: [formats: [html: AlexandriaDevWeb.ErrorHTML]]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
