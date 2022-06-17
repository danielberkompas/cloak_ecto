defmodule Cloak.Ecto.TestPost do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  @behaviour Cloak.Ecto.CustomCursor

  schema "posts" do
    field(:title, Cloak.Ecto.Encrypted.Binary)
    field(:tags, {:array, Cloak.Ecto.Encrypted.Binary})
    field(:metadata, {:map, :string})
    embeds_many(:comments, Cloak.Ecto.TestComment)
    timestamps(type: :utc_datetime)
  end

  @impl Cloak.Ecto.CustomCursor
  def __cloak_cursor_fields__ do
    IO.puts("__cloak_cursor_fields__")
    [:id, :inserted_at]
  end
end
