defmodule App.Schema.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  alias App.SchemaHelpers

  schema "teachers" do
    field :address, :string
    field :cnic, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :phone_no, :string
    field :user_id, :string

    has_one(:user, App.Schema.User)
    belongs_to(:department, App.Schema.Department)

    timestamps()
  end

  @required_fields ~w|
  first_name
  cnic
  address
  department_id
  user_id
  phone_no
  |a

  @optional_fields ~w|
  last_name
  email
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
end
