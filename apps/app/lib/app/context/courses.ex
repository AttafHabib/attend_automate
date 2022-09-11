defmodule App.Context.Courses do
  @moduledoc """
  The Context.Courses context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.{Course, CourseOffer}

  @doc """
  Returns the list of courses.

  ## Examples

      iex> list_courses()
      [%Course{}, ...]

  """
  def list_courses do
    Repo.all(Course)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.

  ## Examples

      iex> get_course!(123)
      %Course{}

      iex> get_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_course!(id), do: Repo.get!(Course, id)

  @doc """
  Creates a course.

  ## Examples

      iex> create_course(%{field: value})
      {:ok, %Course{}}

      iex> create_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.

  ## Examples

      iex> update_course(course, %{field: new_value})
      {:ok, %Course{}}

      iex> update_course(course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a course.

  ## Examples

      iex> delete_course(course)
      {:ok, %Course{}}

      iex> delete_course(course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.

  ## Examples

      iex> change_course(course)
      %Ecto.Changeset{data: %Course{}}

  """
  def change_course(%Course{} = course, attrs \\ %{}) do
    Course.changeset(course, attrs)
  end

  def get_offered_courses(student_id, department_id) do
    query_ = from(c in Course,
      left_join: d in assoc(c, :department),
      where: d.id == ^department_id,
      left_join: std in assoc(c, :students),
      where: is_nil(std.id)
    )
    Repo.all query_
  end

  def get_course_offers(student_id, department_id) do
    query_ = from(co in CourseOffer,
      left_join: c in assoc(co, :course),
      left_join: d in assoc(c, :department),
      where: d.id == ^department_id,
      left_join: std in assoc(co, :student_courses),
      where: is_nil(std.id),
      left_join: t in assoc(co, :teacher),
      select: %{
        id: co.id,
        name: fragment("concat(?, '(', ?, ')', '-', ?, ' ', ?)", c.name, c.course_code, t.first_name, t.last_name),
      }
    )
    Repo.all query_
  end

  def get_by_student_id(student_id) do
    from(c in Course,
      left_join: co in assoc(c, :course_offers),
      left_join: sc in assoc(co, :student_courses),
      left_join: t in assoc(co, :teacher),
      where: sc.student_id == ^student_id,
      select: %{
        id: c.id,
        course_code: c.course_code,
        name: c.name,
        teacher_name: fragment("concat(?, ' ', ?)",t.first_name, t.last_name),

      }
    ) |> Repo.all
  end

  def get_by_teacher_id(teacher_id) do
    from(c in Course,
      left_join: co in assoc(c, :course_offers),
      left_join: t in assoc(co, :teacher),
      left_join: dep in assoc(t, :department),
      where: co.teacher_id == ^teacher_id,
      select: %{
        id: c.id,
        course_offer_id: co.id,
        course_code: c.course_code,
        name: c.name,
        department: %{
          name: dep.name
        }
      }
    ) |> Repo.all
  end
end
