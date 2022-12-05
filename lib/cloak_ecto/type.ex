defmodule Cloak.Ecto.Type do
  @moduledoc false

  @callback __cloak__ :: Keyword.t()

  defmacro __using__(opts) do
    vault = Keyword.fetch!(opts, :vault)
    label = opts[:label]
    closure = !!opts[:closure]

    quote location: :keep do
      @behaviour Ecto.Type
      @behaviour Cloak.Ecto.Type

      @doc false
      @impl Ecto.Type
      def type, do: :binary

      @doc false
      @impl Ecto.Type
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
      @impl Ecto.Type
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
      @impl Ecto.Type
      def embed_as(_format) do
        :self
      end

      @doc false
      @impl Ecto.Type

      def equal?(term1, term2) do
        unwrap(term1) == unwrap(term2)
      end

      defp unwrap(term) when is_function(term, 0) do
        term.()
      end

      defp unwrap(term), do: term

      @doc false
      @impl Ecto.Type
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

      defoverridable after_decrypt: 1,
                     before_encrypt: 1,
                     cast: 1,
                     dump: 1,
                     embed_as: 1,
                     equal?: 2,
                     load: 1,
                     type: 0

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
