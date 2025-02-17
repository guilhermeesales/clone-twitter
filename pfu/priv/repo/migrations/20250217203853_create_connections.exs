defmodule Pfu.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :id_user, references(:users, on_delete: :nothing)
      add :id_connected_user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:connections, [:id_user, :id_connected_user], name: :connections_user_connected_user_unique)
  end
end
