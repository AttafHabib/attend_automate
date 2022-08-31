defmodule App.Schema.CourseOffer do
  use App.Schema
  import Ecto.Changeset

  schema "course_offers" do
    belongs_to(:course, App.Schema.Course)
    belongs_to(:teacher, App.Schema.Teacher)
    has_one :department, through: [:course, :department]

    has_many(:student_courses, App.Schema.StudentCourse)

    timestamp()
  end

  @required_fields ~w|
  course_id
  teacher_id
  |a

  @doc false
  def changeset(course_offer, attrs) do
    course_offer
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
