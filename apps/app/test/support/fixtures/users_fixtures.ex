defmodule App.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> App.Context.Users.create_user()

    user
  end
end
