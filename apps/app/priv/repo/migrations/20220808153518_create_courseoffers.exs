defmodule App.Repo.Migrations.CreateCourseoffers do
  use App.Migration

  def change do
    create table(:course_offers) do
      add :course_id, references(:courses, on_delete: :delete_all)
      add :teacher_id, references(:teachers, on_delete: :delete_all)

      timestamp()
    end
  end
end
