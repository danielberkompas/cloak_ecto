defmodule Cloak.Ecto.Decimal do
  @moduledoc """
  An `Ecto.Type` to encrypt a decimal field, relying on the `Decimal`
  library, which is a dependency of Ecto.

  Decimals are more precise than floats.

  ## Migration

  The database field must be of type `:binary`.

      add :encrypted_field, :binary

  ## Usage

  Define an `Encrypted.Decimal` module in your project:

      defmodule MyApp.Encrypted.Decimal do
        use Cloak.Ecto.Decimal, vault: MyApp.Vault
      end

  Then, define the type of your desired fields:

      schema "table_name" do
        field :encrypted_field, MyApp.Encrypted.Decimal
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

      def cast(value), do: Ecto.Type.cast(:decimal, value)

      def before_encrypt(value) do
        case Ecto.Type.cast(:decimal, value) do
          {:ok, d} -> Decimal.to_string(d)
          _error -> :error
        end
      end

      def after_decrypt(value) do
        case Decimal.new(value) do
          %Decimal{} = d -> d
          _error -> :error
        end
      end
    end
  end
end
