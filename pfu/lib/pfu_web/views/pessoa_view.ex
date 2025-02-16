defmodule PfuWeb.PessoaView do
  use PfuWeb, :view
  alias Pfu.Pessoa

  def first_name(%Pessoa{name: name}) do
    name |> String.split(" ") |> Enum.at(0)
  end
end
