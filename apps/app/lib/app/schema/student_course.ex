defmodule App.Schema.StudentCourse do
  use App.Schema
  import Ecto.Changeset

  schema "student_courses" do
    belongs_to :student, App.Schema.Student
    belongs_to :course_offer, App.Schema.CourseOffer

    timestamp()
  end

  @required_fields ~w|
  student_id
  course_offer_id
  |a

  @doc false
  def changeset(student_course, attrs) do
    student_course
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
