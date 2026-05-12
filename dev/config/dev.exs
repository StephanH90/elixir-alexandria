import Config

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  live_reload: [
    patterns: [
      ~r"lib/alexandria_dev_web/.*(ex|heex)$",
      ~r"../lib/alexandria_web/.*(ex|heex)$"
    ]
  ]

config :alexandria, :storage,
  adapter: AlexandriaDev.Storage.ExAws,
  bucket: System.get_env("ALEXANDRIA_S3_BUCKET", "alexandria-media"),
  access_key_id: System.get_env("ALEXANDRIA_S3_ACCESS_KEY_ID", "dev"),
  secret_access_key: System.get_env("ALEXANDRIA_S3_SECRET_ACCESS_KEY", "dev"),
  endpoint_url: System.get_env("ALEXANDRIA_S3_ENDPOINT_URL", "http://localhost:3900"),
  region: "garage"
