# Closure wrapping

Use the `closure: true` option in local Ecto type definitions to wrap decrypted
values in a zero-arity closure. This prevents the plaintext from accidentally
leaking in some contexts, such as in stacktraces, `Inspect` documents and JSON
serializations.

    defmodule MyApp.Encrypted.WrappedBinary do
      use Cloak.Ecto.Binary, vault: MyApp.Vault, closure: true
    end

In those places where the plaintext value is needed, unwrap the value by
invoking the closure as an anonymous function. Consider using
[Plug.Crypto.prune_args_from_stacktrace/1](https://hexdocs.pm/plug_crypto/Plug.Crypto.html#prune_args_from_stacktrace/1)
in functions that unwrap the plaintext, to prevent leakage in exceptions that
may occur further down the call stack:

    def basic_auth(req, client) do
      # Unwrap string value from password closure
      HTTPClient.basic_auth(req, client.username, client.password.())
    rescue
      e ->
        reraise e, Plug.Crypto.prune_args_from_stacktrace(System.stacktrace())
    end
