defmodule Cloak.Ecto.Binary do
  @moduledoc """
  An `Ecto.Type` to encrypt a binary field.

  ## Migration

  The database field must be of type `:binary`.

      add :encrypted_field, :binary

  ## Usage

  Define an `Encrypted.Binary` module in your project:

      defmodule MyApp.Encrypted.Binary do
        use Cloak.Ecto.Binary, vault: MyApp.Vault
      end

  Then, define the type of your desired fields:

      schema "table_name" do
        field :encrypted_field, MyApp.Encrypted.Binary
      end
  """

  @doc false
  defmacro __using__(opts) do
    opts = Keyword.merge(opts, vault: Keyword.fetch!(opts, :vault))

    quote location: :keep do
      use Cloak.Ecto.Type, unquote(opts)

      if unquote(opts[:embed]) do
        def embed_as(_format) do
          :dump
        end

        def before_decrypt(value) do
          Base.decode64(value, padding: false)
        end

        def after_encrypt(value) do
          {:ok, Base.encode64(value, padding: false)}
        end
      end

      def cast(closure) when is_function(closure, 0) do
        cast(closure.())
      end

      def cast(value) do
        Ecto.Type.cast(:string, value)
      end
    end
  end
end
