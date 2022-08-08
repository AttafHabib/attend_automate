defmodule App.Context.DepartmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.Departments` context.
  """

  @doc """
  Generate a department.
  """
  def department_fixture(attrs \\ %{}) do
    {:ok, department} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> App.Context.Departments.create_department()

    department
  end
end
