defmodule Cloak.Ecto.Integer do
  @moduledoc """
  An `Ecto.Type` to encrypt integer fields.

  ## Migration

  The database field must be of type `:binary`.

      add :encrypted_field, :binary

  ## Usage

  Define an `Encrypted.Integer` module in your project:

      defmodule MyApp.Encrypted.Integer do
        use Cloak.Ecto.Integer, vault: MyApp.Vault
      end

  Then, define the type of your desired fields:

      schema "table_name" do
        field :encrypted_field, MyApp.Encrypted.Integer
      end
  """

  @doc false
  defmacro __using__(opts) do
    opts = Keyword.merge(opts, vault: Keyword.fetch!(opts, :vault))

    quote do
      use Cloak.Ecto.Type, unquote(opts)

      def cast(closure) when is_function(closure, 0) do
        cast(closure.())
      end

      def cast(value) do
        Ecto.Type.cast(:integer, value)
      end

      def after_decrypt(value), do: String.to_integer(value)
    end
  end
end
