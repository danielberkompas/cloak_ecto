defmodule Cloak.Ecto.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloak_ecto,
      version: "1.2.0",
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
      package: package(),
      deps: deps(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:cloak, "~> 1.1.1"},
      {:ecto, "~> 3.0"},
      # Must use a forked version of pbkdf2 to support Erlang 24. Because Hex only
      # allows hex packages to be dependencies, this dep cannot be listed as an
      # optional dependency anymore.
      #
      # See https://github.com/basho/erlang-pbkdf2/pull/12
      {:pbkdf2, "~> 2.0", github: "miniclip/erlang-pbkdf2", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:ecto_sql, ">= 0.0.0", only: [:dev, :test]},
      {:postgrex, ">= 0.0.0", only: [:dev, :test]},
      {:jason, ">= 0.0.0", only: [:dev, :test]},
      {:inch_ex, ">= 0.0.0", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["Daniel Berkompas"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/danielberkompas/cloak_ecto"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "guides/how_to/install.md": [title: "Install Cloak"],
        "guides/how_to/generate_keys.md": [title: "Generate Encryption Keys"],
        "guides/how_to/encrypt_existing_data.md": [title: "Encrypt Existing Data"],
        "guides/how_to/rotate_keys.md": [title: "Rotate Keys"],
        "guides/upgrading/0.9.x_to_1.0.x.md": [title: "0.9.x to 1.0.x"]
      ],
      extra_section: "GUIDES",
      groups_for_extras: [
        "How To": ~r/how_to/,
        Upgrading: ~r/upgrading/
      ],
      groups_for_modules: [
        Behaviours: [
          Cloak.Ecto.CustomCursor
        ],
        "Ecto Types": [
          Cloak.Ecto.Binary,
          Cloak.Ecto.DateTime,
          Cloak.Ecto.Date,
          Cloak.Ecto.Float,
          Cloak.Ecto.HMAC,
          Cloak.Ecto.IntegerList,
          Cloak.Ecto.Integer,
          Cloak.Ecto.Map,
          Cloak.Ecto.NaiveDateTime,
          Cloak.Ecto.PBKDF2,
          Cloak.Ecto.SHA256,
          Cloak.Ecto.StringList,
          Cloak.Ecto.Time
        ]
      ]
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
