defmodule MeowWeb.MeerkatLive.PaginationComponent do
  use MeowWeb, :live_component
  alias MeowWeb.Forms.PaginationForm

  def render(assigns) do
    ~H"""
    <div>
      <%= for {page_number, current_page?} <- pages(@pagination) do %>
        <button phx-click="show_page"
          phx-value-page={page_number}
          phx-target={@myself}
          class={if current_page?, do: "active"}
        >
          <%= page_number %>
        </button>
      <% end %>
    </div>
    <.form :let={f}
      for={:page_size}
      phx-change="set_page_size"
      phx-target={@myslf}
    >
    <%= select f, :page_size,
    [10, 20, 50, 100],
    selected: @pagination.page_size %>
    </.form>
    """
  end

  @spec pages(%{
          :page => any(),
          :page_size => number(),
          :total_count => number(),
          optional(any()) => any()
        }) :: list()
  def pages(%{page_size: page_size, page: current_page, total_count: total_count}) do
    page_count = ceil(total_count / page_size)

    for page_number <- 1..page_count//1 do
      current_page? = page_number == current_page
      {page_number, current_page?}
    end
  end

  def handle_event("show_pages", params, socket) do
    parse_params(params, socket)
  end

  def handle_event("set_page_size", %{"page_size" => params}, socket) do
    parse_params(params, socket)
  end

  def parse_params(params, socket) do
    %{pagination: pagination} = socket.assigns

    case PaginationForm.parse(params, pagination) do
      {:ok, opts} ->
        send(self(), {{:update, opts}})
        {:noreply, socket}

      {:error, _changest} ->
        {:noreply, socket}
    end
  end
end
