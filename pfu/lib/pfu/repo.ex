defmodule Pfu.Repo do
  use Ecto.Repo,
    otp_app: :pfu,
    adapter: Ecto.Adapters.Postgres
    alias Pfu.Pessoa
    #alias Pfu.User


    def tudo(Pessoa) do
      [%Pessoa{id: "1", name: "Joao", username: "joaozim", password: "753"},
      %Pessoa{id: "2", name: "Maria", username: "mariazinha", password: "159"},
      %Pessoa{id: "3", name: "Ana", username: "aninha", password: "321"}]
    end

    #def tudo(User) do
    #  Pfu.Repo.all(User)
    #end

    def tudo(_module), do: []

    def pega_by_id(module, id) do
      Enum.find tudo(module), fn p -> p.id == id end
    end

end
# Para testes de comunicação com o banco, pelo iex:
#iex> alias Pfu.Repo
#iex> Pfu.User
#iex> francisco = %User{name: "Francisco Santos", username: "francisco", password: "123", password_hash: "#8@8*&&^^"}
#iex> ana = %User{name: "Ana Fernandes Pereira", username: "ana", password: "987", password_hash: "8888*****^^^^^^"}
#iex> Repo.insert(francisco)
#iex> Repo.insert(ana)
#iex> user = Repo.get(User, 2)
#iex> User.changeset(user, %{password: "123"})
#iex> Repo.update(User.changeset(Repo.get(User, 1), %{password: "123"}))
