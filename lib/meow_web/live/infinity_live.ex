defmodule MeowWeb.InfinityLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  def render(assigns) do
    ~H"""
    <table class="sticky-headers">
      <thead>
        <th>Id</th>
        <th>Name</th>
      </thead>
      <tbody
        id="meerkats"
        phx-update="append"
        phx-hook="InfinityScroll"
      >
      <%= for meerkat <- @meerkats do %>
        <tr id={"meerkat-#{meerkat.id}"}>
          <td><%= meerkat.id %></td>
          <td><%= meerkat.name %></td>
        </tr>
      <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    count = Meerkats.meerkat_count()

    socket =
      socket
      |> assign(offset: 0, limit: 25, count: count)
      |> load_meerkats()

    {:ok, socket, temporary_assigns: [meerkats: []]}
  end

  def handle_event("load-more", _params, socket) do
    %{offset: offset, limit: limit, count: count} = socket.assigns

    socket =
      if offset < count do
        socket
        |> assign(offset: offset + limit)
        |> load_meerkats()
      else
        socket
      end

    {:noreply, socket}
  end

  defp load_meerkats(socket) do
    %{offset: offset, limit: limit} = socket.assigns
    meerkats = Meerkats.list_meerkats_with_pagination(offset, limit)
    assign(socket, :meerkats, meerkats)
  end
end
