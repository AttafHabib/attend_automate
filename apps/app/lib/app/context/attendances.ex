defmodule App.Context.Attendances do
  @moduledoc """
  The Context.Attendances context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.Attendance

  @doc """
  Returns the list of attendances.

  ## Examples

      iex> list_attendances()
      [%Attendance{}, ...]

  """
  def list_attendances do
    Repo.all(Attendance)
  end

  @doc """
  Gets a single attendance.

  Raises `Ecto.NoResultsError` if the Attendance does not exist.

  ## Examples

      iex> get_attendance!(123)
      %Attendance{}

      iex> get_attendance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_attendance!(id), do: Repo.get!(Attendance, id)

  @doc """
  Creates a attendance.

  ## Examples

      iex> create_attendance(%{field: value})
      {:ok, %Attendance{}}

      iex> create_attendance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_attendance(attrs \\ %{}) do
    %Attendance{}
    |> Attendance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attendance.

  ## Examples

      iex> update_attendance(attendance, %{field: new_value})
      {:ok, %Attendance{}}

      iex> update_attendance(attendance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_attendance(%Attendance{} = attendance, attrs) do
    attendance
    |> Attendance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a attendance.

  ## Examples

      iex> delete_attendance(attendance)
      {:ok, %Attendance{}}

      iex> delete_attendance(attendance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_attendance(%Attendance{} = attendance) do
    Repo.delete(attendance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attendance changes.

  ## Examples

      iex> change_attendance(attendance)
      %Ecto.Changeset{data: %Attendance{}}

  """
  def change_attendance(%Attendance{} = attendance, attrs \\ %{}) do
    Attendance.changeset(attendance, attrs)
  end

  def get_by_s_course(s_course_id, params \\ nil) do
    from(at in Attendance,
      order_by: [asc: at.date]
    )
    |> filter_by_student_course(s_course_id)
    |> filter_by_date(params)
    |> Repo.all
  end

  def filter_by_student_course(query, s_course_ids) when is_list(s_course_ids) do
    from([q] in query, where: q.student_course_id in ^s_course_ids)
  end

  def filter_by_student_course(query, s_course_id) do
    IO.inspect("==========================")
    IO.inspect(s_course_id)
    IO.inspect("==========================")
    from([q] in query, where: q.student_course_id == ^s_course_id)
  end

  def filter_by_date(query, params) when is_nil params do
    IO.inspect("=============1=============")
    IO.inspect(1)
    IO.inspect("=============1=============")
    
    query
  end

  def filter_by_date(query, %{"month" => month}) do
    IO.inspect("=============2=============")
    IO.inspect(month)
    IO.inspect("=============2=============")
    
    from([q] in query, where: fragment("EXTRACT(MONTH FROM ?)", q.date) == ^month)
  end

  def filter_by_date(query, %{"date" => date}) do
    IO.inspect("=============3=============")
    IO.inspect(3)
    IO.inspect("=============3=============")
    from([q] in query, where: q.date == ^date)
  end

end
