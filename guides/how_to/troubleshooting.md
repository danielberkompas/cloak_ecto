# Troubleshooting

### Error when validating default values
If you have a field in your schema with a `:default` value, and are running Ecto
3.6 or later, you may encounter an error like this:

```
** (ArgumentError) errors were found at the given arguments:

  * 1st argument: the table identifier does not refer to an existing ETS table

    (stdlib 4.0) :ets.lookup(MyApp.Vault.Config, :config)
    (cloak 1.1.2) lib/cloak/vault.ex:285: Cloak.Vault.read_config/1
    lib/cloak/vault.ex:224: MyApp.Vault.encrypt/1
    lib/cloak_ecto/type.ex:37: Cloak.Ecto.Encrypted.Binary.dump/1
    (ecto 3.8.4) lib/ecto/schema.ex:2198: Ecto.Schema.validate_default!/3
    (ecto 3.8.4) lib/ecto/schema.ex:1919: Ecto.Schema.__field__/4
    lib/my_app/post.ex:9: (module)
```

This error happens because `cloak` relies on an ETS table which is only available
at runtime, and Ecto 3.6+ tries to validate default values at compile time.

To fix it, add the `:skip_default_validation` option:

```elixir
field :name, MyApp.Encrypted.Binary, default: "foo", skip_default_validation: true
```
