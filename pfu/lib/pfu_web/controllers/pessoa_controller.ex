defmodule PfuWeb.PessoaController do
  use PfuWeb, :controller
  alias Pfu.Repo
  alias Pfu.Pessoa

  def index(conn, _params) do
    pessoas = Repo.tudo(Pessoa)
    render conn, "index.html", pessoas: pessoas
  end
  def show(conn, %{"id" => id}) do
    p = Pfu.Repo.pega_by_id(Pfu.Pessoa, id)
    render conn, "show.html", pessoa: p
  end
end
