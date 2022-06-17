defmodule Cloak.Ecto.TimeTest do
  use ExUnit.Case, async: true

  defmodule Field do
    use Cloak.Ecto.Time, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.Time, vault: Cloak.Ecto.TestVault, closure: true
  end

  setup_all do
    atom_map = %{hour: 12, minute: 0, second: 0}
    string_map = %{"hour" => 12, "minute" => 0, "second" => 0}

    {:ok, atom_map: atom_map, string_map: string_map}
  end

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast rejects invalid input" do
    assert :error == Field.cast("invalid input")
  end

  test ".cast converts maps and strings to naive datetimes", state do
    assert {:ok, ~T[12:00:00]} = Field.cast("12:00:00")
    assert {:ok, ~T[12:00:00]} = Field.cast(~T[12:00:00])
    assert {:ok, ~T[12:00:00]} = Field.cast(state[:atom_map])
    assert {:ok, ~T[12:00:00]} = Field.cast(state[:string_map])
  end

  test ".cast unwraps closures", state do
    assert {:ok, ~T[12:00:00]} = Field.cast(fn -> "12:00:00" end)
    assert {:ok, ~T[12:00:00]} = Field.cast(fn -> ~T[12:00:00] end)
    assert {:ok, ~T[12:00:00]} = Field.cast(fn -> state[:atom_map] end)
    assert {:ok, ~T[12:00:00]} = Field.cast(fn -> state[:string_map] end)
  end

  test ".dump encrypts the value" do
    {:ok, ciphertext} = Field.dump(~T[12:00:00])
    assert ciphertext != ~T[12:00:00]
    assert ciphertext != "12:00:00"
  end

  test ".load decrypts an encrypted value" do
    {:ok, ciphertext} = Field.dump(~T[12:00:00])
    assert {:ok, ~T[12:00:00]} = Field.load(ciphertext)
  end

  test ".load with closure option wraps decrypted value" do
    {:ok, ciphertext} = ClosureField.dump(~T[12:00:00])
    assert {:ok, closure} = ClosureField.load(ciphertext)
    assert is_function(closure, 0)
    assert ~T[12:00:00] = closure.()
  end
end
