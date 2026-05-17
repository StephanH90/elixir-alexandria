defmodule AlexandriaDev.MixProject do
  use Mix.Project

  def project do
    [
      app: :alexandria_dev,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      compilers: [:phoenix_live_view] ++ Mix.compilers(),
      deps: deps(),
      aliases: aliases(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  def application do
    [
      mod: {AlexandriaDev.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:alexandria, path: ".."},
      {:bandit, "~> 1.5"},
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.5"},
      {:hackney, "~> 1.20"},
      {:sweet_xml, "~> 0.7"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.7", runtime: Mix.env() == :dev},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_test, "~> 0.8", only: :test, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: [
        "deps.get",
        "esbuild.install --if-missing",
        "sass.install --if-missing",
        "ash.setup",
        "run priv/repo/seeds.exs"
      ],
      "assets.build": ["esbuild default", "sass default"],
      test: ["ash.reset --quiet", "test"]
    ]
  end
end
