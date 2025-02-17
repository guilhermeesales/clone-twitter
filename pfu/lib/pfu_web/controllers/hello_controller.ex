defmodule PfuWeb.HelloController do
  use PfuWeb, :controller


  #conn |> endPoint |> Controller |> View
  def world(conn, %{"name" => name}) do
  #def world(conn, params) do
    #%{"name" => name} = params
    render conn, "world.html", name: name
  end

end
