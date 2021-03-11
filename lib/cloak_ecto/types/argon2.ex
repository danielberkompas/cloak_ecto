if Code.ensure_loaded?(Argon2) do
  defmodule Cloak.Ecto.Argon2 do
    @moduledoc """
    A custom `Ecto.Type` for hashing fields using `argon2_elixir`.

    ## Why

    If you store a hash of a field's value, you can then query on it as a proxy
    for an encrypted field. This works because Argon2 with static salt is deterministic and
    always results in the same value, while secure encryption does not. Be
    warned, however, that hashing will expose which fields have the same value,
    because they will contain the same hash.

    ## Security

    Argon2 is **more secure** than `Cloak.Ecto.HMAC`, because it uses a
    key stetching algorithm. This makes it harder to brute force offline
    because of the computational/memory overhead

    ## Configuration

    Create an `Argon2` field in your project:

        defmodule MyApp.Hashed.Argon2 do
          use Cloak.Ecto.Argon2, otp_app: :my_app
        end

    Then, configure it with a `:secret`, `:algorithm`, `t_cost`, `m_cost`,
    `parallelism`, `hash_len`, either using mix configuration:

        config :my_app, MyApp.Hashed.Argon2,
          algorithm: :argon2id,
          secret: "secret"
          t_cost: 3,
          m_cost: 12,
          parallelism: 4,
          hash_len: 32

    Or using the `init/1` callback to fetch configuration at runtime:

        defmodule MyApp.Hashed.Argon2 do
          use Cloak.Ecto.Argon2, otp_app: :my_app

          @impl Cloak.Ecto.Argon2
          def init(config) do
            config = Keyword.merge(config, [
              algorithm: :argon2id,
              secret: System.get_env("ARGON_2_SECRET"),
              t_cost: 3,
              m_cost: 12,
              parallelism: 4,
              hash_len: 32
            ])

            {:ok, config}
          end
        end

    ## Usage

    Create the hash field with the type `:binary`. Add it to your schema
    definition like this:

        schema "table" do
          field :field_name, MyApp.Encrypted.Binary
          field :field_name_hash, MyApp.Hashed.Argon2
        end

    Ensure that the hash is updated whenever the target field changes with the
    `put_change/3` function:

        def changeset(struct, attrs \\\\ %{}) do
          struct
          |> cast(attrs, [:field_name, :field_name_hash])
          |> put_hashed_fields()
        end

        defp put_hashed_fields(changeset) do
          changeset
          |> put_change(:field_name_hash, get_field(changeset, :field_name))
        end

    Query the Repo using the `:field_name_hash` in any place you would typically
    query by `:field_name`.

        user = Repo.get_by(User, email_hash: "user@email.com")
    """

    @typedoc "Argon2 algorithms supported by SharedDb.Field.Argon2"
    @type algorithms :: :argon2d | :argon2i | :argon2id

    @doc """
    Configures the `Argon2` field using runtime information.

    ## Example

        @impl SharedDb.Fields.Argon2
        def init(config) do
          config = Keyword.merge(config, [
            algorithm: :argon2id,
            secret: System.get_env("ARGON_2_SECRET"),
            t_cost: 3,
            m_cost: 12,
            parallelism: 4,
            hash_len: 32
          ])

          {:ok, config}
        end
    """
    @callback init(config :: Keyword.t()) :: {:ok, Keyword.t()} | {:error, any}

    @doc false
    defmacro __using__(opts) do
      otp_app = Keyword.fetch!(opts, :otp_app)

      quote do
        @behaviour Cloak.Ecto.Argon2
        @behaviour Ecto.Type
        @algorithms ~w[
          argon2d
          argon2i
          argon2id
        ]a

        @impl Cloak.Ecto.Argon2
        def init(config) do
          {:ok, config}
        end

        @impl Ecto.Type
        def type(), do: :binary

        @impl Ecto.Type
        def cast(nil) do
          {:ok, nil}
        end

        def cast(value) when is_binary(value) do
          {:ok, value}
        end

        def cast(_value) do
          :error
        end

        @impl Ecto.Type
        def dump(nil) do
          {:ok, nil}
        end

        def dump(value) when is_binary(value) do
          config = build_config()
          argon2_type = argon2_type(config[:algorithm])

          hash =
            Argon2.Base.hash_password(value, config[:secret],
              format: :raw_hash,
              argon2_type: argon2_type
            )

          {:ok, hash}
        end

        def dump(_value) do
          :error
        end

        @impl Ecto.Type
        def embed_as(_format) do
          :self
        end

        @impl Ecto.Type
        def equal?(term1, term2) do
          term1 == term2
        end

        @impl Ecto.Type
        def load(value) do
          {:ok, value}
        end

        defoverridable init: 1, type: 0, cast: 1, dump: 1, load: 1, embed_as: 1, equal?: 2

        defp argon2_type(:argon2d), do: 0
        defp argon2_type(:argon2i), do: 1
        defp argon2_type(:argon2id), do: 2

        defp build_config() do
          {:ok, config} =
            unquote(otp_app)
            |> Application.get_env(__MODULE__, [])
            |> init()

          validate_config(config)
        end

        defp validate_config(config) do
          config
          |> validate_config_value(:secret, &valid_secret?/1)
          |> validate_config_value(:algorithm, &valid_algorithm?/1)
          |> validate_config_value(:t_cost, &valid_t_cost?/1)
          |> validate_config_value(:m_cost, &valid_m_cost?/1)
          |> validate_config_value(:parallelism, &valid_parallelism?/1)
          |> validate_config_value(:hash_len, &valid_hash_len?/1)
        end

        defp validate_config_value(config, key, validator_fun) do
          value = config[key]

          unless validator_fun.(value) do
            raise Cloak.InvalidConfig,
                  "#{inspect(value)} is an invalid #{key} for #{inspect(__MODULE__)}"
          end

          config
        end

        defp valid_secret?(secret) when is_binary(secret), do: String.length(secret) > 16
        defp valid_secret?(_secret), do: false

        defp valid_algorithm?(algorithm) when algorithm in @algorithms, do: true
        defp valid_algorithm?(_algorithm), do: false

        # use same bounds as rbnacl
        defp valid_t_cost?(t_cost) when t_cost in 3..10, do: true
        defp valid_t_cost?(_t_cost), do: false

        # use same bounds as rbnacl
        defp valid_m_cost?(m_cost) when m_cost in 3..22, do: true
        defp valid_m_cost?(_m_cost), do: false

        defp valid_parallelism?(parallelism) when parallelism in 1..4, do: true
        defp valid_parallelism?(_parallelism), do: false

        defp valid_hash_len?(hash_len) when hash_len >= 32, do: true
        defp valid_hash_len?(_hash_len), do: false
      end
    end
  end
end
