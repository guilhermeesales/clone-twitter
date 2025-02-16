defmodule PfuWeb.LogoutController do
  use PfuWeb, :controller
  alias PfuWeb.Auth

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    conn
    |> Auth.logout
    |> redirect(to: "/users/new")
  end

end
