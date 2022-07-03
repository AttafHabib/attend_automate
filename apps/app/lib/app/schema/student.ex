defmodule App.Schema.Student do
  use App.Schema

  alias App.SchemaHelpers

  @type t :: %__MODULE__{
               first_name: String.t(),
               last_name: String.t(),
               email: String.t(),
               cnic: String.t(),
               roll_no: String.t(),
               address: String.t(),
               phone_no: String.t()
             }

  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :cnic, :string
    field :roll_no, :string
    field :address, :string
    field :phone_no, :string

    timestamp()
  end

  @required_fields ~w|
  first_name
  cnic
  roll_no
  address
  |a

  @optional_fields ~w|
  last_name
  email
  phone_no
  |a


  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:first_name, max: 30)
    |> validate_length(:cnic, is: 13)
    |> SchemaHelpers.custom_error()
  end

end