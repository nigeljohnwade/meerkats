defmodule MeowWeb.MeerkatLive.FilterComponent do
  use MeowWeb, :live_component

  alias MeowWeb.Forms.FilterForm

  def render(assigns) do
    ~H"""
    <div>
      <p>Search</p>
      <.form :let={f} for={@changeset} as={:filter} phx-submit="search" phx-target={@myself}>
        <div class="form-row">
          <div class="form-group">
            <%= label f, :id %>
            <%= number_input f, :id %>
            <%= error_tag f, :id %>
          </div>
          <div class="form-group">
            <%= label f, :name %>
            <%= text_input f, :name %>
            <%= error_tag f, :name %>
          </div>
          <%= submit "Search" %>
          <button type="reset" name="reset">Reset</button>
        </div>
      </.form>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign_changeset(assigns, socket)}
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case FilterForm.parse(filter) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp assign_changeset(%{filter: filter}, socket) do
    assign(socket, :changeset, FilterForm.change_values(filter))
  end
end
