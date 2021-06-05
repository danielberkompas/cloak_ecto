# Installing Cloak.Ecto

This guide will walk you through installing `Cloak.Ecto` in your project.

### Add the Dependency

First, add `:cloak_ecto` to your dependencies in `mix.exs`:

    {:cloak_ecto, "~> 1.3.0"}

Run `mix deps.get` to fetch the dependency. Since `:cloak_ecto` relies
on `:cloak`, the `:cloak` package will also be installed.

### Generate a Key

You'll need a secret key for encryption. This is easy to generate in the
IEx console.

    $ iex
    iex> 32 |> :crypto.strong_rand_bytes() |> Base.encode64()
    "aJ7HcM24BcyiwsAvRsa3EG3jcvaFWooyQJ+91OO7bRU="

This will generate a relatively strong encryption 256-bit encryption
key encoded with Base64.

### Create a Vault

Next, create a `Cloak.Vault` for your project.

    defmodule MyApp.Vault do
      use Cloak.Vault, otp_app: :my_app
    end

Configure it as shown in the `Cloak.Vault` documentation, with at least one
active cipher. Note that the `:key` needs to be decoded from Base64 encoding into
its raw binary form.

    config :my_app, MyApp.Vault,
      ciphers: [
        default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: Base.decode64!("your-key-here")}
      ]

If you want to fetch keys from system vars, you should use the `init/1` callback
to configure the vault instead:

    # Assumes that you have a CLOAK_KEY environment variable containing a key in
    # Base64 encoding.
    #
    # export CLOAK_KEY="A7x+qcFD9yeRfl3GohiOFZM5bNCdHNu27B0Ozv8X4dE="

    defmodule MyApp.Vault do
      use Cloak.Vault, otp_app: :my_app

      @impl GenServer
      def init(config) do
        config =
          Keyword.put(config, :ciphers, [
            default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: decode_env!("CLOAK_KEY")}
          ])

        {:ok, config}
      end

      defp decode_env!(var) do
        var
        |> System.get_env()
        |> Base.decode64!()
      end
    end

Finally, add your vault to your supervision tree.

    children = [
      MyApp.Vault
    ]

### Create Local Ecto Types

For each type of data you want to encrypt, define a local Ecto type:

    defmodule MyApp.Encrypted.Binary do
      use Cloak.Ecto.Binary, vault: MyApp.Vault
    end

You can find a complete list of available types in the "MODULES" documentation.

### Create Your Schema

If you want to encrypt an existing schema, see the guide on [Encrypting
Existing Data](encrypt_existing_data.html).

If you're starting from scratch with a new `Ecto.Schema`, generate your
fields with the type `:binary`:

    create table(:users) do
      add :email, :binary
      add :email_hash, :binary # will be used for searching
      # ...

      timestamps()
    end

Your schema module should look like this:

    defmodule MyApp.Accounts.User do
      use Ecto.Schema

      import Ecto.Changeset

      schema "users" do
        field :email, MyApp.Encrypted.Binary
        field :email_hash, Cloak.Ecto.SHA256
        # ... other fields

        timestamps()
      end

      @doc false
      def changeset(struct, attrs \\ %{}) do
        struct
        |> cast(attrs, [:email])
        |> put_hashed_fields()
      end

      defp put_hashed_fields(changeset) do
        changeset
        |> put_change(:email_hash, get_field(changeset, :email))
      end
    end

This example also shows how you would make a given field queryable by
creating a mirrored `_hash` field. See `Cloak.Ecto.SHA256` or
`Cloak.Ecto.HMAC` for more details.

## Usage

Your encrypted fields will be transparently encrypted and decrypted as
data are loaded from the database.

    Repo.get(Accounts.User, 1)
    # => %Accounts.User{email: "test@example.com", email_hash: <<115, 6, 45, 135, 41, ...>>}

You can query by the mirrored `_hash` fields:

    Repo.get_by(Accounts.User, email_hash: "test@example.com")
    # => %Accounts.User{email: "test@example.com", ...}

And you're done! `Cloak.Ecto` is successfully installed.
