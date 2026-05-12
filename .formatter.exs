[
  import_deps: [:ash, :ash_postgres, :ash_phoenix, :phoenix, :phoenix_live_view],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Spark.Formatter]
]
