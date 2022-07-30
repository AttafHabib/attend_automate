defmodule App.Schema.User do
  use App.Schema

  alias Argon2
  alias App.SchemaHelpers

  @type t :: %__MODULE__{
               username: String.t(),
               email: String.t(),
               password: String.t()
             }


  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string

    has_one(:user_role, App.Schema.UserRole)
    has_one :student, App.Schema.Student, foreign_key: :user_id

    timestamp()
  end

  @required_fields ~w|
    username
    email
    password
  |a

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:username, min: 3, max: 30)
    |> SchemaHelpers.custom_error() #Must be before any custom message as it appends field with error reason
    |> validate_email(:email)
    |> put_password_hash()
  end

  @spec put_password_hash(%Ecto.Changeset{})::%Ecto.Changeset{}
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}}=changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  @spec put_password_hash(%Ecto.Changeset{})::%Ecto.Changeset{}
  defp put_password_hash(changeset), do: changeset

  @spec validate_email(%Ecto.Changeset{}, atom)::%Ecto.Changeset{}
  defp validate_email(%Ecto.Changeset{changes: changes} = changeset,field) do
    #    changeset=validate_format(changeset,field,~r/.+@\w+\.\w+/)
    changeset=validate_format(changeset,field, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    if(changes[field] == "") do
      changeset
    else
      update_in(
        changeset.errors,
        &(Enum.map &1, fn {:email, {"has invalid format", val}} ->
          {:email,
            {"Email format isn't correct. Please enter correct email", val}
          }
          {key, val} -> {key, val}
        end)
      )
    end
  end

end
