defmodule Cloak.Ecto.BinaryTest do
  use ExUnit.Case

  defmodule Field do
    use Cloak.Ecto.Binary, vault: Cloak.Ecto.TestVault
  end

  defmodule ClosureField do
    use Cloak.Ecto.Binary, vault: Cloak.Ecto.TestVault, closure: true
  end

  @invalid_types [%{}, 123, 123.33, []]

  describe ".type/0" do
    test "returns :binary" do
      assert Field.type() == :binary
    end
  end

  describe ".cast/1" do
    test "leaves nil unchanged" do
      assert {:ok, nil} == Field.cast(nil)
    end

    test "leaves binaries unchanged" do
      assert {:ok, "binary"} = Field.cast("binary")
    end

    test "unwraps closures" do
      assert {:ok, "binary"} = Field.cast(fn -> "binary" end)
    end

    test "returns :error on other types" do
      for invalid <- @invalid_types do
        assert :error == Field.cast(invalid)
      end
    end
  end

  describe "dump/1" do
    test "leaves nil unchanged" do
      assert {:ok, nil} == Field.dump(nil)
    end

    test "encrypts binaries" do
      {:ok, ciphertext} = Field.dump("value")
      assert ciphertext != "value"
    end

    test "returns :error on other types" do
      for invalid <- @invalid_types do
        assert :error == Field.dump(invalid)
      end
    end
  end

  describe ".load/1" do
    test "decrypts the ciphertext" do
      {:ok, ciphertext} = Field.dump("value")
      assert {:ok, "value"} = Field.load(ciphertext)
    end

    test "closure option wraps decrypted value" do
      {:ok, ciphertext} = ClosureField.dump("value")
      assert {:ok, closure} = ClosureField.load(ciphertext)
      assert is_function(closure, 0)
      assert "value" = closure.()
    end
  end

  describe ".equal?/1" do
    test "unwraps closures to compare equality" do
      schema = {
        # values in the schema right now
        %{value: fn -> "value" end},
        # type definitons
        %{value: ClosureField}
      }

      # Build a changeset where the value of the field hasn't actually changed
      changeset =
        Ecto.Changeset.cast(
          schema,
          %{value: "value"},
          [:value]
        )

      # The changeset should not make any changes
      assert changeset.changes == %{}

      # Simulate a changeset where the value of the field has changed
      changeset =
        Ecto.Changeset.cast(
          schema,
          %{value: "something else"},
          [:value]
        )

      # The changeset should now have a change for the field
      assert changeset.changes == %{value: "something else"}
    end
  end
end
