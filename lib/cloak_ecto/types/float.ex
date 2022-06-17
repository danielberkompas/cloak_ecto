defmodule Cloak.Ecto.Float do
  @moduledoc """
  An `Ecto.Type` to encrypt a float field.

  ## Migration

  The database field must be of type `:binary`.

      add :encrypted_field, :binary

  ## Usage

  Define an `Encrypted.Float` module in your project:

      defmodule MyApp.Encrypted.Float do
        use Cloak.Ecto.Float, vault: MyApp.Vault
      end

  Then, define the type of your desired fields:

      schema "table_name" do
        field :encrypted_field, MyApp.Encrypted.Float
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
        Ecto.Type.cast(:float, value)
      end

      def after_decrypt(value), do: String.to_float(value)
    end
  end
end
