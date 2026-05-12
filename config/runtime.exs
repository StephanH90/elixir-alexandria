import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :alexandria, Alexandria.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end

if config_env() in [:prod, :test] do
  if bucket = System.get_env("ALEXANDRIA_S3_BUCKET") do
    config :alexandria, :storage,
      bucket: bucket,
      access_key_id: System.fetch_env!("ALEXANDRIA_S3_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("ALEXANDRIA_S3_SECRET_ACCESS_KEY"),
      endpoint_url: System.fetch_env!("ALEXANDRIA_S3_ENDPOINT_URL"),
      region: System.get_env("ALEXANDRIA_S3_REGION", "garage"),
      presigned_url_ttl_seconds: 3600
  end
end
