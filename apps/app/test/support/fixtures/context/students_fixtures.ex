defmodule App.Context.StudentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.Students` context.
  """

  @doc """
  Generate a student.
  """
  def student_fixture(attrs \\ %{}) do
    {:ok, student} =
      attrs
      |> Enum.into(%{
        address: "some address",
        cnic: "some cnic",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        phone_no: "some phone_no",
        roll_no: "some roll_no"
      })
      |> App.Context.Students.create_student()

    student
  end
end
