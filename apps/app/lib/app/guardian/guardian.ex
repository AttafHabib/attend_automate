defmodule App.Guardian do
  use Guardian, otp_app: :app

  alias App.Context.Users
  alias App.Schema.User

  @spec subject_for_token(%User{}, map()) :: {:ok, String.t()}
  def subject_for_token(user, _claims) do

    {:ok, to_string(user.id)}
  end

  @spec resource_from_claims(map()) :: {:ok, %User{}}
  def resource_from_claims(%{"sub" => id}) do
    user = Users.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

end