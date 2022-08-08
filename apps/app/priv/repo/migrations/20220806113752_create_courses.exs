defmodule App.Repo.Migrations.CreateCourses do
  use App.Migration

  def change do
    create table(:courses) do
      add :name, :string, [null: false]
      add :course_code, :string, [size: 7, null: false]

      add :department_id, references(:departments, on_delete: :delete_all)

      timestamp()
    end

    create unique_index(:courses, [:course_code])
  end
end
