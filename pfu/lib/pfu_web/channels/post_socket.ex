defmodule PfuWeb.PostChannel do
  use PfuWeb, :channel

  def join("posts", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_like", %{"post_id" => post_id}, socket) do
    broadcast(socket, "post_liked", %{post_id: post_id})
    {:noreply, socket}
  end

  def handle_in("new_reply", %{"post_id" => post_id}, socket) do
    broadcast(socket, "post_replied", %{post_id: post_id})
    {:noreply, socket}
  end
end
