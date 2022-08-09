defmodule App.Context.CourseOffers do
  @moduledoc """
  The Context.CourseOffers context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.CourseOffer

  @doc """
  Returns the list of courseoffers.

  ## Examples

      iex> list_courseoffers()
      [%CourseOffer{}, ...]

  """
  def list_courseoffers do
    Repo.all(CourseOffer)
  end

  @doc """
  Gets a single course_offer.

  Raises `Ecto.NoResultsError` if the Course offer does not exist.

  ## Examples

      iex> get_course_offer!(123)
      %CourseOffer{}

      iex> get_course_offer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course_offer!(id), do: Repo.get!(CourseOffer, id)

  @doc """
  Creates a course_offer.

  ## Examples

      iex> create_course_offer(%{field: value})
      {:ok, %CourseOffer{}}

      iex> create_course_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course_offer(attrs \\ %{}) do
    %CourseOffer{}
    |> CourseOffer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course_offer.

  ## Examples

      iex> update_course_offer(course_offer, %{field: new_value})
      {:ok, %CourseOffer{}}

      iex> update_course_offer(course_offer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course_offer(%CourseOffer{} = course_offer, attrs) do
    course_offer
    |> CourseOffer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course_offer.

  ## Examples

      iex> delete_course_offer(course_offer)
      {:ok, %CourseOffer{}}

      iex> delete_course_offer(course_offer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course_offer(%CourseOffer{} = course_offer) do
    Repo.delete(course_offer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course_offer changes.

  ## Examples

      iex> change_course_offer(course_offer)
      %Ecto.Changeset{data: %CourseOffer{}}

  """
  def change_course_offer(%CourseOffer{} = course_offer, attrs \\ %{}) do
    CourseOffer.changeset(course_offer, attrs)
  end

  def list_dropdown(department_id) do
    from(sc in CourseOffer,
      left_join: t in assoc(sc, :teacher),
      left_join: c in assoc(sc, :course),
      left_join: dept in assoc(c, :department),
      where: dept.id == ^department_id,
      select: %{
        id: sc.id,
        name: fragment("concat(?, '(', ?, ') - ',?, ' ', ?)", c.name, c.course_code, t.first_name, t.last_name)
      }
    )
    |> Repo.all
    |> Enum.map(&({&1.name, &1.id}))
  end
end
