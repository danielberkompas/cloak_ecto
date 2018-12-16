defmodule Cloak.Ecto.TestRepo do
  use Ecto.Repo,
    otp_app: :cloak_ecto,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok,
     Keyword.merge(opts,
       username: "postgres",
       password: "postgres",
       database: "cloak_ecto_test",
       hostname: "localhost",
       pool: Ecto.Adapters.SQL.Sandbox,
       priv: "test/support/"
     )}
  end
end
