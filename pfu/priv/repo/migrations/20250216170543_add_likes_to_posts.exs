defmodule Pfu.Repo.Migrations.AddLikesToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :likes, :integer, default: 0, null: false
    end
  end
end
