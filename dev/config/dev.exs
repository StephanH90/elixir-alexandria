import Config

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  reloadable_apps: [:alexandria_dev, :alexandria],
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

config :phoenix_live_reload, :dirs, [".", ".."]
