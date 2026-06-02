import Config

# Inherit Alexandria.Repo connection from the parent's config; override DB only if needed.
config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  database: "alexandria_dev",
  pool_size: 10

config :alexandria,
  ash_domains: [Alexandria.Core],
  ecto_repos: [Alexandria.Repo]

config :alexandria_dev, AlexandriaDev.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  database: "alexandria_dev_consumer",
  pool_size: 10

config :alexandria_dev,
  ash_domains: [AlexandriaDev.Core, AlexandriaDev.ExampleDomain],
  ecto_repos: [Alexandria.Repo, AlexandriaDev.Repo]

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  url: [host: "localhost"],
  secret_key_base: String.duplicate("a", 64),
  live_view: [signing_salt: "alexandria-dev-salt"],
  pubsub_server: AlexandriaDev.PubSub,
  render_errors: [formats: [html: AlexandriaDevWeb.ErrorHTML]]

config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.21.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/* --alias:uikit=../deps/elixir_uikit/priv/vendor/uikit/js/uikit.min.js),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :dart_sass,
  version: "1.77.8",
  default: [
    args:
      ~w(--load-path=../deps/elixir_uikit/priv/vendor/uikit/scss --load-path=vendor-shim css/app.scss ../priv/static/assets/css/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"
