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

  def get_by_s_course(s_course_id, month \\ nil) do
    from(at in Attendance,
      where: at.student_course_id == ^s_course_id,
      order_by: [asc: at.date]
    )
    |> filter_by_month(month)
    |> Repo.all
  end

  def filter_by_month(query, month) when is_nil month do
    query
  end

  def filter_by_month(query, month) do
    from([q] in query, where: fragment("EXTRACT(MONTH FROM ?)", q.date) == ^month)
  end

end
