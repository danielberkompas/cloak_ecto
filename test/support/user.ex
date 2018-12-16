defmodule Cloak.Ecto.TestUser do
  use Ecto.Schema

  schema "users" do
    field(:name, :string)
    field(:email, Cloak.Ecto.Encrypted.Binary)
    field(:email_hash, Cloak.Ecto.Hashed.HMAC)
    timestamps(type: :utc_datetime)
  end
end
