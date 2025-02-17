defmodule Pfu.Esquema do
  alias Pfu.Esquema
  defmacro esquema(_any, do: bloco) do
    {_, _, s} = bloco
    quote do
      defstruct unquote(s)
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Esquema, only: [esquema: 2]
    end
  end

end
