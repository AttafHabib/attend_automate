defmodule App.Repo.Migrations.AlterTableStudentsAddDepartmentReference do
  use App.Migration

  @table :students
  def change do
    alter table(@table) do
      add :department_id, references(:departments)
    end
  end
end
