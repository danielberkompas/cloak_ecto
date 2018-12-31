defmodule Cloak.Ecto.Hashed.HMAC do
  use Cloak.Ecto.HMAC, otp_app: :cloak

  def init(_config) do
    {:ok,
     [
       algorithm: :sha512,
       secret: "secret"
     ]}
  end
end
