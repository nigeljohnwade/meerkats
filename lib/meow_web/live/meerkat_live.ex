defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats
  alias MeowWeb.Forms.SortingForm
  alias MeowWeb.Forms.FilterForm

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    path = Routes.live_path(socket, __MODULE__, opts)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  def parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params) do
      socket
      |> assign_sorting(sorting_opts)
      |> assign_filter(filter_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filter()
    end
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_meerkats(socket) do
    %{sorting: sorting} = socket.assigns
    assign(socket, :meerkats, Meerkats.list_meerkats(sorting))
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end
end
