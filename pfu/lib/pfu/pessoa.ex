defmodule Pfu.Pessoa do
  use Pfu.Esquema
  alias Pfu.Pessoa

  esquema "pessoas" do
    :id
    :name
    :username
    :password
  end

  defp make_change(pessoa, attrs) do
    [_ | keys] = Map.keys(%Pessoa{})
    attrs = attrs |> Map.take(keys)
    pessoa |> Map.merge(attrs, fn _k, _v1, v2 -> v2 end)
  end

  def changeset(pessoa, attrs, hash: false), do: make_change(pessoa, attrs)

  def changeset(pessoa, attrs, hash: true) do
    pessoa = make_change(pessoa, attrs)
    put_password_hash(pessoa)
  end
  defp put_password_hash(pessoa) do
    Map.replace(pessoa, :password, Comeonin.Bcrypt.hashpwsalt(pessoa.password))
  end
end
