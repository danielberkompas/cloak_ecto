# Cloak.Ecto
[![Coverage Status](https://coveralls.io/repos/github/danielberkompas/cloak_ecto/badge.svg?branch=master)](https://coveralls.io/github/danielberkompas/cloak_ecto?branch=master)
[![Build Status](https://danielberkompas.semaphoreci.com/badges/cloak_ecto/branches/master.svg?style=shields)](https://danielberkompas.semaphoreci.com/projects/cloak_ecto)

Easily encrypt fields in your [Ecto](https://github.com/elixir-ecto/ecto)
schemas. Relies on [Cloak](https://github.com/danielberkompas/cloak) for
encryption.

- [Hex Documentation](https://hexdocs.pm/cloak_ecto)

## Usage

`Cloak.Ecto` helps you create `Ecto.Type` modules which automatically encrypt
and decrypt your data. You simply define a type and set the type of your fields, and
`Cloak.Ecto` handles the rest.

```elixir
defmodule MyApp.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: MyApp.Vault
end
```

```elixir
defmodule MyApp.EctoSchema do
  use Ecto.Schema

  schema "table_name" do
    field :encrypted_field, MyApp.Encrypted.Binary

    # ...
  end
end
```

When Ecto writes the fields to the database, Cloak encrypts the values into a
binary blob, using a configured encryption algorithm chosen by you.

```elixir
iex> Repo.insert!(%MyApp.EctoSchema{encrypted_field: "plaintext"})
08:46:08.862 [debug] QUERY OK db=3.4ms
INSERT INTO "table_name" ("encrypted_field") 
VALUES ($1) RETURNING "id", "encrypted_field" [
  <<1,10, 65, 69, 83, 46, 67, 84, 82, 46, 86, 49, 
    69, 92, 173, 219, 203, 238, 26, 58, 236, 5, 
    104, 23, 12, 10, 182, 31, 221, 89, 22, 58, 
    34, 79, 109, 30, 70, 254, 56, 93, 102, 84>>
]
```

Likewise, when Ecto reads the encrypted blob out of the database, Cloak will
automatically decrypt the value into the intended data type at runtime.

```elixir
iex> Repo.get(MyApp.EctoSchema, 1)
%MyApp.EctoSchema{encrypted_field: "plaintext"}
```

For complete usage instructions, see the [Hex documentation](https://hexdocs.pm/cloak_ecto).

## Notable Features

- Transparent, easy to use encryption for database fields
- Fully compatible with umbrella projects
- Bring your own encryption algorithm, if you want
- Mix task for key rotation: `mix cloak.migrate`

## Security Notes

-  **Supported Algorithms**: Cloak's built-in encryption modules rely on Erlang's 
   `:crypto` module. Cloak supports the following algorithms out of the box:
   
    - AES.GCM
    - AES.CTR

- **Encrypted Data Not Searchable**: Cloak uses random IVs for each ciphertext. This 
  means that the same value will not encrypt to the same value twice. As a result,
  encrypted columns are not queryable. However, Cloak does provide easy ways to
  create hashed, searchable columns.

- **Runtime Data is not Encrypted**: Cloak encrypts data _at rest_ in the database. 
  The data in your Ecto structs at runtime is not encrypted.

- **No Support for User-specific Encryption Keys**: Cloak's `Ecto.Type` modules do not
  support user-specific encryption keys, due to limitations on the `Ecto.Type` 
  behaviour. However, you can still use Cloak's ciphers to implement these in your 
  application logic.

## Use Without Ecto

If you want to use `Cloak` without Ecto, see
[`cloak`](https://hex.pm/packages/cloak) instead.

## Local Development

To develop this library locally, you will need to install the correct version
of Elixir and Postgres. The easiest way to set everything up is with Docker
and [docker-compose](https://docs.docker.com/compose/):

```sh
$ cd cloak_ecto
# Runs the bin/test script in the context of Docker
$ docker-compose run app bin/test
# To access a terminal with mix, use this command:
$ docker-compose run app bash
# Run any command of your choosing:
root@234098234oij:/app# mix docs
```