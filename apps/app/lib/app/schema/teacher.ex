defmodule App.Schema.Teacher do
  use App.Schema

  alias App.SchemaHelpers

  schema "teachers" do
    field :address, :string
    field :cnic, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :phone_no, :string
#    field :user_id, :string

    belongs_to(:user, App.Schema.User)

    belongs_to(:department, App.Schema.Department)

    has_many(:course_offers, App.Schema.CourseOffer)
    has_many :courses, through: [:course_offers, :course]

    timestamp()
  end

  @required_fields ~w|
  first_name
  cnic
  address
  department_id
  phone_no
  email
  |a

  @optional_fields ~w|
  last_name
  user_id
  |a

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:cnic, is: 13)
    |> SchemaHelpers.custom_error()
  end

  def changeset_course(teacher, attrs) do
    teacher
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_assoc(:course_offers, with: &App.Schema.CourseOffer.changeset/2)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:cnic, is: 13)
    |> SchemaHelpers.custom_error()
  end
end
