defmodule App.Context.Files do
  @moduledoc """
  The Context.Files context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.File


  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_file(attrs \\ %{}) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_by_tag!("abc",123)
      %File{}

      iex> get_by_tag!("abc", 456)
      ** (Ecto.NoResultsError)

  """
  def get_by_tag!(tag, user_id), do: Repo.one(from f in File, where: f.user_id == ^user_id and f.tag == ^tag)

  def list_by_tag!(tag, user_id), do: Repo.all(from f in File, where: f.user_id == ^user_id and f.tag == ^tag)
end