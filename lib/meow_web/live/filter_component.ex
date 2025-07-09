defmodule MeowWeb.MeerkatLive.FilterComponent do
  use MeowWeb, :live_component

  alias MeowWeb.Forms.FilterForm

  def render(assigns) do
    ~H"""
    <div>
      <.form let={f} for={@changeset} as="filter" phx-submit="search" phx-target={@myself}>
        <div>
          <div>
            <%= label f, :id %>
            <%= number_input f, :id %>
            <%= error_tag f, :id %>
            </div>
            <div>
            <%= label f, :name %>
            <%= number_input f, :name %>
            <%= error_tag f, :name %>
          </div>
          <%= submit "Search" %>
        </div>
      </.form>
    </div>
    """
  end

  def update(%{filter: filter}, socket) do
    {:ok, assign(socket, :changeset, FilterForm.change_values(filter))}
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case FilterForn.parse(filter) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
