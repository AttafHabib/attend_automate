defmodule App.Schema.Course do
  use App.Schema
  import Ecto.Changeset
  alias App.SchemaHelpers


  schema "courses" do
    field :course_code, :string
    field :name, :string

    belongs_to(:department, App.Schema.Department)

    timestamp()
  end

  @required_fields ~w|
  department_id
  course_code
  name
  |a

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:course_code, is: 7)
    |> SchemaHelpers.custom_error()
  end
end
