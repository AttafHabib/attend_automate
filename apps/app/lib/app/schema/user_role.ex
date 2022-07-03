defmodule App.Schema.UserRole do
  use App.Schema

  alias App.SchemaHelpers

  @type t :: %__MODULE__{
               user_id: binary(),
               role_id: binary(),
             }

  schema "user_roles" do

    belongs_to(:user, App.Schema.User)
    belongs_to(:role, App.Schema.Role)
    timestamp()
  end

  @required_fields ~w|
  user_id
  role_id
  |a


  def changeset(student, attrs \\ %{}) do
    student
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> SchemaHelpers.custom_error()
  end

end