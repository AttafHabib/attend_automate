defmodule App.Schema.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attendances" do
    field :date, :date
    field :status, :boolean, default: false


    belongs_to(:student_course, App.Schema.StudentCourse)

    timestamps()
  end

  @doc false
  def changeset(attendance, attrs) do
    attendance
    |> cast(attrs, [:status, :date, :student_course_id])
    |> validate_required([:status, :date, :student_course_id])
  end
end
