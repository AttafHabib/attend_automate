defmodule App.Schema.User do
  use App.Schema

  alias Argon2

  @type t :: %__MODULE__{
               username: String.t(),
               cnic: String.t(),
               email: String.t(),
               password: String.t()
             }


  schema "users" do
    field :username, :string
    field :cnic, :string
    field :email, :string
    field :password, :string

    timestamp()
  end

  @required_fields ~w|
    username
    cnic
    email
    password
  |a

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:username, min: 3, max: 30)
    |> validate_length(:cnic, is: 13)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}}=changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
