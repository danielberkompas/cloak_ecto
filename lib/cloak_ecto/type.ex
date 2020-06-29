defmodule Cloak.Ecto.Type do
  @moduledoc false

  @callback __cloak__ :: Keyword.t()

  defmacro __using__(opts) do
    vault = Keyword.fetch!(opts, :vault)
    label = opts[:label]
    closure = !!opts[:closure]

    quote location: :keep do
      @behaviour Cloak.Ecto.Type

      @doc false
      def type, do: :binary

      @doc false
      def cast(nil) do
        {:ok, nil}
      end

      def cast(closure) when is_function(closure, 0) do
        cast(closure.())
      end

      def cast(value) do
        {:ok, value}
      end

      @doc false
      def dump(nil) do
        {:ok, nil}
      end

      def dump(value) do
        with {:ok, value} <- cast(value),
             value <- before_encrypt(value),
             {:ok, value} <- encrypt(value) do
          {:ok, value}
        else
          _other ->
            :error
        end
      end

      @doc false
      def load(nil) do
        {:ok, nil}
      end

      def load(value) do
        with {:ok, value} <- decrypt(value) do
          value = after_decrypt(value)
          if unquote(closure) do
            {:ok, fn -> value end}
          else
            {:ok, value}
          end
        else
          _other ->
            :error
        end
      end

      @doc false
      def before_encrypt(value), do: to_string(value)

      @doc false
      def after_decrypt(value), do: value

      defoverridable type: 0, cast: 1, dump: 1, load: 1, before_encrypt: 1, after_decrypt: 1

      @doc false
      def __cloak__ do
        [vault: unquote(vault), label: unquote(label), closure: unquote(closure)]
      end

      defp encrypt(plaintext) do
        if unquote(label) do
          unquote(vault).encrypt(plaintext, unquote(label))
        else
          unquote(vault).encrypt(plaintext)
        end
      end

      defp decrypt(ciphertext) do
        unquote(vault).decrypt(ciphertext)
      end
    end
  end
end
