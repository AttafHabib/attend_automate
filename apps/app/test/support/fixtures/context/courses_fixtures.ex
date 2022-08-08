defmodule App.Context.CoursesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.Courses` context.
  """

  @doc """
  Generate a course.
  """
  def course_fixture(attrs \\ %{}) do
    {:ok, course} =
      attrs
      |> Enum.into(%{
        course_code: "some course_code",
        name: "some name"
      })
      |> App.Context.Courses.create_course()

    course
  end
end
