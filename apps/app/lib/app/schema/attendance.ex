defmodule App.Schema.Attendance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attendances" do
    field :date, :string
    field :status, :boolean, default: false


    belongs_to(:student_course, App.Schema.StudentCourse)

    timestamps()
  end

  @doc false
  def changeset(attendance, attrs) do
    attendance
    |> cast(attrs, [:status, :date])
    |> validate_required([:status, :date])
  end
end
