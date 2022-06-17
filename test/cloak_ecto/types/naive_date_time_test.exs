defmodule Cloak.Ecto.NaiveDateTimeTest do
  use ExUnit.Case, async: true

  defmodule Field do
    use Cloak.Ecto.NaiveDateTime, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.NaiveDateTime, vault: Cloak.Ecto.TestVault, closure: true
  end

  setup_all do
    atom_map = %{year: 2017, month: 1, day: 5, hour: 12, minute: 0, second: 0}

    string_map = %{
      "year" => 2017,
      "month" => 1,
      "day" => 5,
      "hour" => 12,
      "minute" => 0,
      "second" => 0
    }

    {:ok, atom_map: atom_map, string_map: string_map}
  end

  test ".type is :binary" do
    assert Field.type() == :binary
  end

  test ".cast rejects invalid input" do
    assert :error == Field.cast("invalid input")
  end

  test ".cast converts maps and strings to naive datetimes", state do
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast("2017-01-05T12:00:00")
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(~N[2017-01-05 12:00:00])
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(state[:atom_map])
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(state[:string_map])
  end

  test ".cast unwraps closures", state do
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(fn -> "2017-01-05T12:00:00" end)
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(fn -> ~N[2017-01-05 12:00:00] end)
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(fn -> state[:atom_map] end)
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.cast(fn -> state[:string_map] end)
  end

  test ".dump encrypts the value" do
    {:ok, ciphertext} = Field.dump(~N[2017-01-05 12:00:00])
    assert ciphertext != ~N[2017-01-05 12:00:00]
    assert ciphertext != "2017-01-05 12:00:00"
  end

  test ".load decrypts an encrypted value" do
    {:ok, ciphertext} = Field.dump(~N[2017-01-05 12:00:00])
    assert {:ok, ~N[2017-01-05 12:00:00]} = Field.load(ciphertext)
  end

  test ".load with closure option wraps decrypted value" do
    {:ok, ciphertext} = ClosureField.dump(~N[2017-01-05 12:00:00])
    assert {:ok, closure} = ClosureField.load(ciphertext)
    assert is_function(closure, 0)
    assert ~N[2017-01-05 12:00:00] = closure.()
  end
end
