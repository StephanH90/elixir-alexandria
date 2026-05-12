defmodule AlexandriaDev.MixProject do
  use Mix.Project

  def project do
    [
      app: :alexandria_dev,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_test, "~> 0.8", only: :test, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "run priv/repo/seeds.exs"],
      test: ["ash.setup --quiet", "test"]
    ]
  end
end
