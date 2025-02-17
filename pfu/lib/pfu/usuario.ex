defmodule Pfu.Usuario do
  use Pfu.Esquema
  alias Pfu.Usuario

  esquema "usuarios" do
    :nome
    :username
    :password
    :age
    :email
  end

  defp make_change(user, attrs) do
    [_ | keys] = Map.keys(%Usuario{})
    attrs = attrs |> Map.take(keys)
    user |> Map.merge(attrs, fn _k, _v1, v2 -> v2 end)
  end

  def changeset(user, attrs, hash: false), do: make_change(user, attrs)

  def changeset(user, attrs, hash: true) do
    user = make_change(user, attrs)
    put_password_hash(user)
  end
  defp put_password_hash(user) do
    #Map.replace(user, :password, Comeonin.Bcrypt.hashpwsalt(user.password))
    Map.replace(user, :password, Bcrypt.hash_pwd_salt(user.password))
  end
end
