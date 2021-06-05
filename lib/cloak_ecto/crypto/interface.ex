defmodule Cloak.Ecto.Crypto.Interface do
  @moduledoc false
  @type algorithm :: atom()
  @type secret :: binary
  @type value :: iodata

  @callback hmac(atom(), secret, value) :: binary
end
