defmodule ScannerData.Repo.Migrations.GivePostsArrayField do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:tags, {:array, :binary}, default: [])
    end
  end
end
