defmodule App.Context.Roles do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Guardian

  alias App.Schema.Role


  def get_by_role(role) do
    from(r in Role, where: r.name == ^role)|>Repo.one
  end
end