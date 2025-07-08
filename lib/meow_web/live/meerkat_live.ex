defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, assign_meerkats(socket)}
  end

  defp assign_meerkats(socket) do
    assign(socket, :meerkats, Meerkats.list_meerkats())
  end
end
