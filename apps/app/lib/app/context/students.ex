defmodule App.Context.Students do
  @moduledoc """
  The Context.Students context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.Student

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students()
      [%Student{}, ...]

  """
  def list_students() do
    Repo.all(Student)
  end

  @doc """
  Returns the list of students having no user profiles.
  ## Examples

       iex> list_students(true)
        [%Student{}, ...]
  """
  def list_students(profile = false) do
    from(s in Student,
      where: is_nil(s.user_id)
    )|> Repo.all
  end

  @doc """
  Gets a single student.

  Raises if the Student does not exist.

  ## Examples

      iex> get_student!(123)
      %Student{}

  """
  def get_student!(id), do: Repo.one(from s in Student, where: s.id == ^id)

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %Student{}}

      iex> create_student(%{field: bad_value})
      {:error, ...}

  """
  def create_student(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a student.

  ## Examples

      iex> update_student(student, %{field: new_value})
      {:ok, %Student{}}

      iex> update_student(student, %{field: bad_value})
      {:error, ...}

  """
  def update_student(%Student{} = student, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Student.

  ## Examples

      iex> delete_student(student)
      {:ok, %Student{}}

      iex> delete_student(student)
      {:error, ...}

  """
  def delete_student(%Student{} = student) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking student changes.

  ## Examples

      iex> change_student(student)
      %Todo{...}

  """
  def change_student(%Student{} = student, _attrs \\ %{}) do
    Student.changeset(student, _attrs)
  end
end
