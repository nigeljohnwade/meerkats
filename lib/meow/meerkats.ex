defmodule Meow.Meerkats do
  @moduledoc """
  The Meerkats context.
  """

  import Ecto.Query, warn: false
  alias Meow.Repo

  alias Meow.Meerkats.Meerkat

  def list_meerkats(opts) do
    from(m in Meerkat)
    |> filter(opts)
    |> sort(opts)
    |> Repo.all()
  end

  def list_meerkats() do
    Repo.all(Meerkat)
  end

  defp filter(query, opts) do
    query
    |> filter_by_id(opts)
    |> filter_by_name(opts)
  end

  defp filter_by_id(query, %{id: id}) when is_integer(id) do
    where(query, id: ^id)
  end

  defp filter_by_id(query, _opts), do: query

  defp filter_by_name(query, %{name: name})
       when is_binary(name) and name != "" do
    query_string = "%#{name}%"
    where(query, [m], ilike(m.name, ^query_string))
  end

  defp filter_by_name(query, _opts), do: query

  # called when sort has options in the second argument
  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name] and sort_dir in [:asc, :desc] do
    order_by(query, {^sort_dir, ^sort_by})
  end

  # called when sort has no options in the second argument
  # Q: why is _opts specified?
  # Q: what is the significance of the underscore?
  defp sort(query, _opts), do: query
end
