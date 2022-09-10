defmodule App.Context.UserRoles do
  @moduledoc """
  The UserRoles context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Guardian

  alias App.Schema.UserRole

  def get_user_role!(user_id) do
    from(ur in UserRole,
      where: ur.user_id == ^user_id
    )|> Repo.one
  end
end