defmodule Cloak.Ecto.FloatTest do
  use ExUnit.Case

  defmodule Field do
    use Cloak.Ecto.Float, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.Float, vault: Cloak.Ecto.TestVault, closure: true
  end

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast rejects invalid input" do
    assert :error == Field.cast("blahblah")
  end

  test ".cast converts integers and strings to floats" do
    assert {:ok, 21.0} = Field.cast(21.0)
    assert {:ok, 21.0} = Field.cast(21)
    assert {:ok, 21.0} = Field.cast("21")
    assert {:ok, 21.0} = Field.cast("21.0")
  end

  test ".cast unwraps closures" do
    assert {:ok, 21.0} = Field.cast(fn -> 21.0 end)
    assert {:ok, 21.0} = Field.cast(fn -> 21 end)
    assert {:ok, 21.0} = Field.cast(fn -> "21" end)
    assert {:ok, 21.0} = Field.cast(fn -> "21.0" end)
  end

  test ".dump encrypts the value" do
    {:ok, ciphertext} = Field.dump(1.0)
    assert ciphertext != 1.0
    assert ciphertext != "1.0"
  end

  test ".load decrypts an encrypted value" do
    {:ok, ciphertext} = Field.dump(1.0)
    assert {:ok, 1.0} = Field.load(ciphertext)
  end

  test ".load with closure option wraps decrypted value" do
    {:ok, ciphertext} = ClosureField.dump(1.0)
    assert {:ok, closure} = ClosureField.load(ciphertext)
    assert is_function(closure, 0)
    assert 1.0 = closure.()
  end
end
