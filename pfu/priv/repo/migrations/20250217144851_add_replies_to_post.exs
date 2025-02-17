defmodule Pfu.Repo.Migrations.AddRepliesToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :replies, :integer, default: 0, null: false
    end
  end
end
