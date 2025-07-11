defmodule MeowWeb.MeerkatLive.SortingComponent do
  use MeowWeb, :live_component

  def render(assigns) do
    ~H"""
    <p>
      <%= @display_name %> <%= chevron(@sorting, @key) %>
      <button phx-click="sort" phx-target={@myself}>
         <%= next_action(@sorting, @key) %>
      </button>
    </p>
    """
  end

  def handle_event("sort", _params, socket) do
    %{sorting: %{sort_dir: sort_dir}, key: key} = socket.assigns
    sort_dir = if sort_dir == :asc, do: :desc, else: :asc
    opts = %{sort_by: key, sort_dir: sort_dir}
    send(self(), {:update, opts})
    {:noreply, assign(socket, :sorting, opts)}
  end

  def chevron(%{sort_by: sort_by, sort_dir: sort_dir}, key)
      when sort_by == key do
    if sort_dir == :asc, do: "Ascending", else: "Descending"
  end

  def chevron(_opts, _key), do: ""

  def next_action(%{sort_by: sort_by, sort_dir: sort_dir}, key) do
    cond do
      sort_dir == :desc and sort_by == key ->
        "sort ascending"

      sort_by != key ->
        "sort ascending"

      sort_dir == :asc and sort_by == key ->
        "sort descending"

      true ->
        ""
    end
  end
end
