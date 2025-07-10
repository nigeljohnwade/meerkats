defmodule Meow.Meerkats do
  @moduledoc """
  The Meerkats context.
  """

  import Ecto.Query, warn: false
  alias Meow.Repo

  alias Meow.Meerkats.Meerkat

  def meerkat_count(), do: Repo.aggregate(Meerkat, :count)

  def list_meerkats(opts) do
    from(m in Meerkat)
    |> sort(opts)
    |> filter(opts)
    |> Repo.all()
  end

  def list_meerkats_with_pagination(offset, limit) do
    from(m in Meerkat)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end

  def list_meerkats_with_total_count(opts) do
    query = from(m in Meerkat) |> filter(opts)

    total_count = Repo.aggregate(query, :count)

    result =
      query
      |> sort(opts)
      |> paginate(opts)
      |> Repo.all()

    %{meerkats: result, total_count: total_count}
  end

  defp sort(query, %{sort_dir: sort_dir, sort_by: sort_by})
       when sort_dir in [:asc, :desc] and
              sort_by in [:id, :name] do
    order_by(query, {^sort_dir, ^sort_by})
  end

  defp sort(query, _opts), do: query

  defp paginate(query, %{page: page, page_size: page_size})
       when is_integer(page) and is_integer(page_size) do
    offset = max(page - 1, 0) * page_size

    query
    |> limit(^page_size)
    |> offset(^offset)
  end

  defp paginate(query, _opts), do: query

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
end
