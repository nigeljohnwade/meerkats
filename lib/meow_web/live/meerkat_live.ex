defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(_params, _url, socket) do
    {:noreply, assign_meerkats(socket)}
  end

  def handle_info({:update, opts}, socket) do
    path = Routes.live_path(socket, __MODULE__, opts)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp assign_meerkats(socket) do
    assign(socket, :meerkats, Meerkats.list_meerkats())
  end
end
