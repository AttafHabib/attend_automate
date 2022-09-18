defmodule App.Context.StudentCourses do
  @moduledoc """
  The Context.StudentCourses context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.{StudentCourse, Attendance}

  @doc """
  Returns the list of student_courses.

  ## Examples

      iex> list_student_courses()
      [%StudentCourse{}, ...]

  """
  def list_student_courses do
    Repo.all(StudentCourse)
  end

  @doc """
  Gets a single student_course.

  Raises `Ecto.NoResultsError` if the Student course does not exist.

  ## Examples

      iex> get_student_course!(123)
      %StudentCourse{}

      iex> get_student_course!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student_course!(id), do: Repo.get!(StudentCourse, id)

  @doc """
  Creates a student_course.

  ## Examples

      iex> create_student_course(%{field: value})
      {:ok, %StudentCourse{}}

      iex> create_student_course(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student_course(attrs \\ %{}) do
    %StudentCourse{}
    |> StudentCourse.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student_course.

  ## Examples

      iex> update_student_course(student_course, %{field: new_value})
      {:ok, %StudentCourse{}}

      iex> update_student_course(student_course, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student_course(%StudentCourse{} = student_course, attrs) do
    student_course
    |> StudentCourse.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a student_course.

  ## Examples

      iex> delete_student_course(student_course)
      {:ok, %StudentCourse{}}

      iex> delete_student_course(student_course)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student_course(%StudentCourse{} = student_course) do
    Repo.delete(student_course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student_course changes.

  ## Examples

      iex> change_student_course(student_course)
      %Ecto.Changeset{data: %StudentCourse{}}

  """
  def change_student_course(%StudentCourse{} = student_course, attrs \\ %{}) do
    StudentCourse.changeset(student_course, attrs)
  end


  def get_student_course_preloads(c_offer_id, params) do
    from(sc in StudentCourse,
      where: sc.course_offer_id == ^c_offer_id,
      preload: [:student, attendances: ^(from atd in Attendance, where: atd.date == ^params["date"])]
    )
#    |> filter_attendance()
    |> Repo.all()
  end

  def get_by_user_ids(user_ids, c_offer_id) when is_list user_ids do
    from(sc in StudentCourse,
      left_join: std in assoc(sc, :student),
      where: std.user_id in ^user_ids and sc.course_offer_id == ^c_offer_id
    )
    |> Repo.all()
  end

  def filter_by_user_ids(user_ids, c_offer_id) when is_list user_ids do
    from(sc in StudentCourse,
      left_join: std in assoc(sc, :student),
      where: not(std.user_id in ^user_ids) and sc.course_offer_id == ^c_offer_id
    )
    |> Repo.all()
  end

#  def filter_attendance(_, params) when is_nil params do
#    params
#  end

#  def filter_attendance(query, %{"date" => date}) do
#    from([..., atd] in query, where: atd.date == ^date)
#  end
end
