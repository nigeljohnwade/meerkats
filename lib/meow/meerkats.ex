defmodule Meow.Meerkats do
  @moduledoc """
  The Meerkats context.
  """

  import Ecto.Query, warn: false
  alias Meow.Repo

  alias Meow.Meerkats.Meerkat

  def list_meerkats() do
    Repo.all(Meerkat)
  end

  def list_meerkats(opts) do
    from(m in Meerkat)
    |> sort(opts)
    |> Repo.all()
  end

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
