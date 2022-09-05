defmodule App.Schema.Student do
  use App.Schema
#  import Ecto.Changeset

  alias App.SchemaHelpers

  @type t :: %__MODULE__{
               id: binary,
               first_name: String.t(),
               last_name: String.t(),
               email: String.t(),
               cnic: String.t(),
               roll_no: String.t(),
               address: String.t(),
               phone_no: String.t(),
#               user_id: binary
             }

  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :cnic, :string
    field :roll_no, :string
    field :address, :string
    field :phone_no, :string

    #    field :user_id, :integer

    belongs_to :user, App.Schema.User

    belongs_to(:department, App.Schema.Department)

    has_many(:s_courses, App.Schema.StudentCourse)
#    has_many(:courses, through: [:student_courses, :course_offer, :course])
    has_many(:face_images, through: [:user,  :files])
    has_one(:full_image, through: [:user,  :files])

    timestamps()
  end

  @required_fields ~w|
  first_name
  cnic
  roll_no
  address
  department_id
  phone_no
  email
  |a

  @optional_fields ~w|
  last_name
  user_id
  |a


  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:cnic, is: 13)
    |> SchemaHelpers.custom_error()
  end

  def changeset_s_course(student, attrs \\ %{}) do
    student
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:student_courses, with: &App.Schema.StudentCourse.changeset/2)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:cnic, is: 13)
    |> SchemaHelpers.custom_error()
  end

end