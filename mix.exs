defmodule Alexandria.MixProject do
  use Mix.Project

  def project do
    [
      app: :alexandria,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Alexandria.Application, []}
    ]
  end

  defp deps do
    [
      {:ash, "~> 3.23"},
      {:simple_sat, "~> 0.1"},
      {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, "~> 2.0"},
      {:phoenix, "~> 1.8.3"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:phoenix_html, "~> 4.1"},
      {:elixir_uikit, "~> 0.7"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:spark, "~> 2.2"},
      {:phoenix_test, "~> 0.8", only: :test, runtime: false},
      {:usage_rules, "~> 1.0", only: :dev},
      {:igniter, "~> 0.6", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["ash.setup"],
      test: ["ash.setup --quiet", "test"],
      precommit: [
        "format",
        "compile --warnings-as-errors",
        "deps.unlock --unused",
        "ash.codegen --check"
      ]
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths(:dev) ++ ["test/support"]
  defp elixirc_paths(_), do: ["lib"] ++ extra_paths()

  # Consumer apps can append source directories to Alexandria's compile
  # by setting `config :alexandria, :extra_elixirc_paths, [...]` in their
  # own `config/config.exs`. This lets a consumer put `Spark.Dsl.Fragment`
  # modules in its own repo and have them compile alongside Alexandria,
  # avoiding the "fragment module not loaded when dep compiles" trap.
  # Paths should be absolute (use `Path.expand/2` against `__DIR__`).
  defp extra_paths, do: Application.get_env(:alexandria, :extra_elixirc_paths, [])
end
