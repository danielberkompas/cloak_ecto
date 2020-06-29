defmodule Cloak.Ecto.IntegerTest do
  use ExUnit.Case

  defmodule Field do
    use Cloak.Ecto.Integer, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.Integer, vault: Cloak.Ecto.TestVault, closure: true
  end

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast rejects invalid input" do
    assert :error = Field.cast("21.5")
    assert :error = Field.cast(21.5)
    assert :error = Field.cast("blahblahblah")
  end

  test ".cast accepts valid input" do
    assert {:ok, 21} = Field.cast(21)
    assert {:ok, 21} = Field.cast("21")
  end

  test ".cast unwraps closures" do
    assert {:ok, 21} = Field.cast(fn -> 21 end)
    assert {:ok, 21} = Field.cast(fn -> "21" end)
  end

  test ".dump encrypts the integer" do
    {:ok, ciphertext} = Field.dump(100)
    assert ciphertext != 100
    assert ciphertext != "100"
  end

  test ".load decrypts the integer" do
    {:ok, ciphertext} = Field.dump(100)
    assert {:ok, 100} = Field.load(ciphertext)
  end

  test ".load with closure option wraps decrypted value" do
    {:ok, ciphertext} = ClosureField.dump(100)
    assert {:ok, closure} = ClosureField.load(ciphertext)
    assert is_function(closure, 0)
    assert 100 = closure.()
  end
end
