defmodule App.Schema.Role do
  use App.Schema

  alias App.SchemaHelpers

  @type t :: %__MODULE__{
               name: String.t(),
             }

  schema "roles" do
    field :name, :string

    has_many(:user_role, App.Schema.UserRole)
    timestamp()
  end

  @required_fields ~w|
  name
  |a


  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> SchemaHelpers.custom_error()
  end

end