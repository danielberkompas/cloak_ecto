defmodule Cloak.Ecto.Argon2Test do
  use ExUnit.Case

  defmodule TestArgon2 do
    use Cloak.Ecto.Argon2, otp_app: :shared_db

    @impl true
    def init(_config) do
      {:ok,
       [
         algorithm: :argon2id,
         secret: "some super long secret",
         t_cost: 3,
         m_cost: 12,
         parallelism: 4,
         hash_len: 32
       ]}
    end
  end

  @invalid_types [%{}, [], 123, 123.22]

  describe ".type/0" do
    test "returns :binary" do
      assert :binary == TestArgon2.type()
    end
  end

  describe ".cast/1" do
    test "returns nils unchanged" do
      assert {:ok, nil} = TestArgon2.cast(nil)
    end

    test "returns binaries unchanged" do
      assert {:ok, "binary"} = TestArgon2.cast("binary")
      assert {:ok, <<1>>} = TestArgon2.cast(<<1>>)
    end

    test "returns :error for all other types" do
      for type <- @invalid_types do
        assert :error = TestArgon2.cast(type)
      end
    end
  end

  describe ".dump/1" do
    test "returns nils unchanged" do
      assert {:ok, nil} = TestArgon2.dump(nil)
    end

    test "hashes binaries" do
      expected_hash =
        Argon2.Base.hash_password("plaintext", "some super long secret",
          format: :raw_hash,
          argon2_type: 2
        )

      assert {:ok, actual_hash} = TestArgon2.dump("plaintext")
      assert expected_hash == actual_hash
    end

    test "returns :error for all other types" do
      for type <- @invalid_types do
        assert :error = TestArgon2.dump(type)
      end
    end
  end

  describe ".load/1" do
    test "returns value unchanged" do
      assert {:ok, "value"} = TestArgon2.load("value")
    end
  end
end
