import Config

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    sass:
      {DartSass, :install_and_run,
       [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"lib/alexandria_dev_web/.*(ex|heex)$",
      ~r"../lib/alexandria_web/.*(ex|heex)$",
      ~r"priv/static/assets/.*(css|js)$"
    ]
  ]

config :alexandria, :storage,
  adapter: AlexandriaDev.Storage.ExAws,
  bucket: System.get_env("ALEXANDRIA_S3_BUCKET", "alexandria-media"),
  access_key_id: System.get_env("ALEXANDRIA_S3_ACCESS_KEY_ID", "dev"),
  secret_access_key: System.get_env("ALEXANDRIA_S3_SECRET_ACCESS_KEY", "dev"),
  endpoint_url: System.get_env("ALEXANDRIA_S3_ENDPOINT_URL", "http://localhost:3900"),
  region: "garage"

config :ash, policies: [
    show_policy_breakdowns?: true,
    no_filter_static_forbidden_reads?: false
  ]

