defmodule Pfu.Connections do
  use Ecto.Schema
  import Ecto.Changeset

  schema "connections" do
    belongs_to :user, Pfu.User, foreign_key: :id_user  # Usuário que faz a conexão
    belongs_to :connected_user, Pfu.User, foreign_key: :id_connected_user  # Usuário com quem ele está se conectando

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:id_user, :id_connected_user])
    |> validate_required([:id_user, :id_connected_user])
  end
end
