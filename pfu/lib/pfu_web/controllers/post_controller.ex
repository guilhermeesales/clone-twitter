defmodule PfuWeb.PostController do
  use PfuWeb, :controller
  import Ecto.Query
  alias Pfu.Connections
  alias Pfu.Repo
  alias Pfu.Post
  

  plug :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]  

    posts = 
      from(p in Post, order_by: [desc: p.likes])
      |> Repo.all()
      |> Repo.preload(:user)

    posts_with_connections = Enum.map(posts, fn post ->
      connection = Repo.get_by(Connections, id_user: current_user.id, id_connected_user: post.user_id)

      Map.put(post, :is_connected, connection != nil)
    end)

    render(conn, "index.html", posts: posts_with_connections)
  end


  def show(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    render(conn, "show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user

    post_params = Map.put(post_params, "user_id", current_user.id)

    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post criado com sucesso!")
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def like(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Ecto.Changeset.change(post, likes: post.likes + 1)

    case Repo.update(changeset) do
      {:ok, post} ->
        # Transmite para o canal "posts" o evento "post_liked"
        PfuWeb.Endpoint.broadcast("posts", "post_liked", %{post_id: post.id, likes: post.likes})
        json(conn, %{likes: post.likes})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Não foi possível curtir o post."})
    end
  end

  def reply(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Ecto.Changeset.change(post, replies: post.replies + 1)

    case Repo.update(changeset) do
      {:ok, post} ->
        # Transmite para o canal "posts" o evento "post_replied"
        PfuWeb.Endpoint.broadcast("posts", "post_replied", %{post_id: post.id, replies: post.replies})
        json(conn, %{lreplies: post.replies})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Não foi possível curtir o post."})
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post, %{})
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post atualizado com sucesso!")
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    case Repo.get(Post, id) do
      nil ->
        conn
        |> put_flash(:error, "Post não encontrado.")
        |> redirect(to: Routes.post_path(conn, :profile))
      post ->
        Repo.delete(post)
        conn
        |> put_flash(:info, "Post removido com sucesso!")
        |> redirect(to: Routes.post_path(conn, :profile))
    end
  end

  def profile(conn, _params) do
    current_user = conn.assigns.current_user

    my_posts =
      from(p in Post, where: p.user_id == ^current_user.id, preload: [:user])
      |> Repo.all()

    IO.inspect(my_posts, label: "Posts do usuário logado")
    render(conn, "profile.html", posts: my_posts)
  end
end
