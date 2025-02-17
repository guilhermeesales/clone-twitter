defmodule PfuWeb.ConnectionController do
  use PfuWeb, :controller
  import Ecto.Query
  alias Pfu.Connections
  alias Pfu.Repo
  alias Pfu.Post
  alias Pfu.User

  plug :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    followed_ids =
      from(c in Connections,
        where: c.id_user == ^current_user.id,
        select: c.id_connected_user
      )
      |> Repo.all()

    followed_users =
      from(u in User,
        where: u.id in ^followed_ids
      )
      |> Repo.all()

    render(conn, "index.html", users: followed_users)
  end


  def conectar(conn, %{"id" => post_id}) do
    current_user = conn.assigns.current_user

    post = Repo.get(Post, post_id) |> Repo.preload(:user)
    target_user = post.user 

    existing_connection = Repo.get_by(Connections, id_user: current_user.id, id_connected_user: target_user.id)

    if existing_connection do
      conn
      |> put_flash(:info, "Você já está conectado com #{target_user.name}.")
      |> redirect(to: Routes.post_path(conn, :index))  
    else
      changeset = Connections.changeset(%Connections{}, %{id_user: current_user.id, id_connected_user: target_user.id})

      case Repo.insert(changeset) do
        {:ok, _connection} ->
          conn
          |> put_flash(:info, "Você se conectou com #{target_user.name}!")
          |> redirect(to: Routes.post_path(conn, :index))  

        {:error, changeset} ->
          conn
          |> put_flash(:error, "Ocorreu um erro ao tentar conectar.")
          |> redirect(to: Routes.post_path(conn, :index))  
      end
    end
  end


  def desconectar(conn, %{"id" => post_id}) do
    current_user = conn.assigns.current_user

    post = Repo.get(Post, post_id) |> Repo.preload(:user)
    target_user = post.user 

    existing_connection = Repo.get_by(Connections, id_user: current_user.id, id_connected_user: target_user.id)

     posts = 
      from(p in Post, order_by: [desc: p.likes])
      |> Repo.all()
      |> Repo.preload(:user)

    case Repo.get(Connections, existing_connection.id) do
      nil ->
        conn
        |> put_flash(:error, "Essa conexão não existe")
        |> redirect(to: Routes.post_path(conn, :index))
      connection ->
        Repo.delete(connection)
        conn
        |> put_flash(:info, "Desconexão feita com sucesso")
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end 
end
