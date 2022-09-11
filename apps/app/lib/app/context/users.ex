defmodule App.Context.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Guardian

  alias App.Schema.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
   (from User, preload: [user_role: :role])
   |> Repo.all
   |> preload_profile
  end

  def preload_profile(users) do
    Enum.map(users, fn user ->
      case user.user_role.role_id do
        2 -> Repo.preload(user, :student)
        3 -> Repo.preload(user, :teacher)
        _ -> user
      end
    end)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(email), do: Repo.one(from u in User, where: u.email == ^email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user \\ %User{}, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns an 2 element tuple where first element is :error or :ok while second is
  User struct or error_name atom after authenticating User

  ## Examples

      iex> authenticate_user(email, password)
      %{:ok, %User{}}

  """
  @spec authenticate_user(String.t(), String.t()) :: {:ok, %User{}} | {:error, atom}
  def authenticate_user(email, plain_text_password) do
    case get_user(email) do
      nil -> Argon2.no_user_verify()
             {:error, :invalid_email}
      user -> if Argon2.verify_pass(plain_text_password, user.password) do
                {:ok, user}
              else
                {:error, :invalid_password}
              end
    end
  end

  def verify_user(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} -> {:ok, user} = Guardian.resource_from_claims(claims)
                       {:ok, Repo.preload(user, :user_role)}
      {:error, reason} -> {:error, reason}
    end
  end
end
