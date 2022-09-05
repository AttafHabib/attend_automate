defmodule App.Repo.Migrations.CreateAttendanceTable do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :status, :boolean
      add :date, :string
      add :student_course_id, references(:student_courses)

      timestamps()
    end
  end
end
