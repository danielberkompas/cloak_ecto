defmodule Cloak.EctoTest do
  use ExUnit.Case
  doctest Cloak.Ecto

  test "greets the world" do
    assert Cloak.Ecto.hello() == :world
  end
end
