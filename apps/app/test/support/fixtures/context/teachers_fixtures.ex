defmodule App.Context.TeachersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.Teachers` context.
  """

  @doc """
  Generate a teacher.
  """
  def teacher_fixture(attrs \\ %{}) do
    {:ok, teacher} =
      attrs
      |> Enum.into(%{
        address: "some address",
        cnic: "some cnic",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        phone_no: "some phone_no"
      })
      |> App.Context.Teachers.create_teacher()

    teacher
  end
end
