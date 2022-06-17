defmodule Cloak.Ecto.SHA256Test do
  use ExUnit.Case

  alias Cloak.Ecto.SHA256, as: Field

  describe ".cast/1" do
    test "leaves nil unchanged" do
      assert {:ok, nil} = Field.cast(nil)
    end

    test "leaves binary values unchanged" do
      assert {:ok, "value"} = Field.cast("value")
    end

    test "converts other values to binary" do
      assert {:ok, "123"} = Field.cast(123)
    end
  end

  describe ".dump/1" do
    test "hashes the value with sha256" do
      assert {:ok, hash} = Field.dump("value")
      assert hash == :crypto.hash(:sha256, "value")
    end
  end

  describe ".load/1" do
    test "leaves the value unchanged" do
      assert {:ok, "value"} = Field.load("value")
    end
  end

  describe ".equal?/2" do
    test "return true on same values and hashed values" do
      assert Field.equal?("value", "value")
      assert Field.equal?(:crypto.hash(:sha256, "value"), :crypto.hash(:sha256, "value"))
      assert Field.equal?("value", :crypto.hash(:sha256, "value"))
      assert Field.equal?(:crypto.hash(:sha256, "value"), "value")
    end

    test "return false on different values" do
      refute Field.equal?("value", "not equal")
      refute Field.equal?(:crypto.hash(:sha256, "value"), :crypto.hash(:sha256, "not equal"))
    end
  end
end
