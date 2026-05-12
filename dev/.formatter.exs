# Used by "mix format"
[
  import_deps: [:phoenix, :phoenix_live_view],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test,priv}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
