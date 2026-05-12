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
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.5"},
      {:hackney, "~> 1.20"},
      {:sweet_xml, "~> 0.7"},
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
  defp elixirc_paths(_), do: ["lib"]
end
