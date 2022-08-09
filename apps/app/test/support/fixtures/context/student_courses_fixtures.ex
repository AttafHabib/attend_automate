defmodule App.Context.StudentCoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.StudentCourses` context.
  """

  @doc """
  Generate a student_course.
  """
  def student_course_fixture(attrs \\ %{}) do
    {:ok, student_course} =
      attrs
      |> Enum.into(%{

      })
      |> App.Context.StudentCourses.create_student_course()

    student_course
  end
end
