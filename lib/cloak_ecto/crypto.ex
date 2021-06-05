defmodule Cloak.Ecto.Crypto do
  @moduledoc false
  @behaviour Cloak.Ecto.Crypto.Interface

  if System.otp_release() >= "22" do
    @impl Cloak.Ecto.Crypto.Interface
    def hmac(algorithm, key, data) do
      :crypto.mac(:hmac, algorithm, key, data)
    end
  else
    @impl Cloak.Ecto.Crypto.Interface
    def hmac(algorithm, key, data) do
      :crypto.hmac(algorithm, key, data)
    end
  end
end
