defmodule Cloak.Ecto.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloak_ecto,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/danielberkompas/cloak_ecto",
      description: "Encrypted fields for Ecto",
      deps: deps(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cloak, github: "danielberkompas/cloak"},
      {:ecto, "~> 3.0.0"},
      {:flow, "~> 0.14"},
      {:pbkdf2, "~> 2.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:ecto_sql, ">= 0.0.0", only: [:dev, :test]},
      {:postgrex, ">= 0.0.0", only: [:dev, :test]},
      {:jason, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: :test}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ],
      groups_for_modules: [
        Behaviours: [
          Cloak.Ecto.CustomCursor
        ],
        "Ecto Types": ~r/Fields/
      ]
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
