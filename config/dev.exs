import Config

config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "alexandria_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ash, policies: [show_policy_breakdowns?: true]

config :alexandria, :storage,
  adapter: AlexandriaDev.Storage.ExAws,
  bucket: System.get_env("ALEXANDRIA_S3_BUCKET", "alexandria-media"),
  access_key_id: System.get_env("ALEXANDRIA_S3_ACCESS_KEY_ID", "dev"),
  secret_access_key: System.get_env("ALEXANDRIA_S3_SECRET_ACCESS_KEY", "dev"),
  endpoint_url: System.get_env("ALEXANDRIA_S3_ENDPOINT_URL", "http://localhost:3900"),
  region: "garage"
