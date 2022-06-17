defmodule Cloak.Ecto.MapTest do
  use ExUnit.Case

  defmodule Field do
    use Cloak.Ecto.Map, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.Map, vault: Cloak.Ecto.TestVault, closure: true
  end

  @map %{"key" => "value"}

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast rejects invalid types" do
    assert :error = Field.cast("binary")
    assert :error = Field.cast(123)
    assert :error = Field.cast(123.0)
    assert :error = Field.cast(hello: :world)
  end

  test ".cast accepts maps" do
    assert {:ok, %{"hello" => "world"}} = Field.cast(%{"hello" => "world"})
  end

  test ".cast unwraps closures" do
    assert {:ok, @map} = Field.cast(fn -> @map end)
  end

  test ".before_encrypt converts the map to a JSON string" do
    assert "{\"key\":\"value\"}" = Field.before_encrypt(@map)
  end

  test ".dump encrypts the map" do
    {:ok, ciphertext} = Field.dump(@map)
    assert is_binary(ciphertext)
    assert ciphertext != @map
  end

  test ".load decrypts the map" do
    {:ok, ciphertext} = Field.dump(@map)
    assert {:ok, @map} = Field.load(ciphertext)
  end

  test ".load with closure option wraps decrypted value" do
    {:ok, ciphertext} = ClosureField.dump(@map)
    assert {:ok, closure} = ClosureField.load(ciphertext)
    assert is_function(closure, 0)
    assert @map = closure.()
  end
end
