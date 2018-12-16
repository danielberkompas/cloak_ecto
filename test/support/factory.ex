defmodule Cloak.Ecto.Factory do
  @moduledoc false

  @doc """
  Creates a user.
  """
  def create_user(email) do
    email = Cloak.Ecto.TestVault.encrypt!(email, :secondary)
    {:ok, email_hash} = Cloak.Ecto.Hashed.HMAC.dump(email)

    {_count, [user]} =
      Cloak.Ecto.TestRepo.insert_all(
        "users",
        [
          %{
            name: "John Smith",
            email: email,
            email_hash: email_hash,
            inserted_at: DateTime.utc_now(),
            updated_at: DateTime.utc_now()
          }
        ],
        returning: [:id, :name, :email, :email_hash]
      )

    user
  end
end
