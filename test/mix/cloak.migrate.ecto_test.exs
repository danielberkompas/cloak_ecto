defmodule Cloak.Ecto.MigrateTest do
  use Cloak.Ecto.DataCase, async: false

  import ExUnit.CaptureIO
  import IO.ANSI, only: [yellow: 0, green: 0, reset: 0]

  setup do
    [user: Factory.create_user("test@email.com")]
  end

  test "migrates existing rows to new version when command line args given" do
    output =
      capture_io(fn ->
        Mix.Task.rerun("cloak.migrate.ecto", [
          "-r",
          "Cloak.Ecto.TestRepo",
          "-s",
          "Cloak.Ecto.TestUser"
        ])
      end)

    assert output == """
           Migrating #{yellow()}Cloak.Ecto.TestUser#{reset()}...
           #{green()}Migration complete!#{reset()}
           """
  end

  test "reads from configuration" do
    Application.put_env(:cloak_ecto, :cloak_repo, Cloak.Ecto.TestRepo)
    Application.put_env(:cloak_ecto, :cloak_schemas, [Cloak.Ecto.TestUser])

    output =
      capture_io(fn ->
        Mix.Task.rerun("cloak.migrate.ecto", [])
      end)

    assert output == """
           Migrating #{yellow()}Cloak.Ecto.TestUser#{reset()}...
           #{green()}Migration complete!#{reset()}
           """

    Application.delete_env(:cloak_ecto, :cloak_repo)
    Application.delete_env(:cloak_ecto, :cloak_schemas)
  end

  test "raises error if called with incorrect arguments" do
    bad_args = [
      [],
      ["-r", "Cloak.Ecto.TestRepo"],
      ["-s", "Cloak.Ecto.TestSchema"]
    ]

    for args <- bad_args do
      assert_raise Mix.Error, fn ->
        Mix.Task.rerun("cloak.migrate.ecto", args)
      end
    end
  end
end
