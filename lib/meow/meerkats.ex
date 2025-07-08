defmodule Meow.Meerkats do
  @moduledoc """
  The Meerkats context.
  """

  import Ecto.Query, warn: false
  alias Meow.Repo

  alias Meow.Meerkats.Meerkat

  def list_meerkats do
    Repo.all(Meerkat)
  end
end
