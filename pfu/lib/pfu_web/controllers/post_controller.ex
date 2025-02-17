defmodule PfuWeb.PostController do
  use PfuWeb, :controller
  import Ecto.Query
  alias Pfu.Repo
  alias Pfu.Post

  plug :authenticate_user when action in [:index, :show, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    posts =
      from(p in Post, order_by: [desc: p.likes])
      |> Repo.all()
      |> Repo.preload(:user)

    IO.inspect(posts, label: "Posts ordenados por likes")
    render(conn, "index.html", posts: posts)
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
    case Repo.get(Post, id) do
      nil ->
        conn
        |> put_flash(:error, "Post não encontrado.")
        |> redirect(to: Routes.post_path(conn, :index))
      post ->
        Repo.delete(post)
        conn
        |> put_flash(:info, "Post removido com sucesso!")
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end
end
