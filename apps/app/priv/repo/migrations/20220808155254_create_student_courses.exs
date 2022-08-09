defmodule App.Repo.Migrations.CreateStudentCourses do
  use App.Migration

  def change do
    create table(:student_courses) do
      add :course_offer_id, references(:course_offers, on_delete: :delete_all)
      add :student_id, references(:students, on_delete: :delete_all)

      timestamp()
    end
  end
end
