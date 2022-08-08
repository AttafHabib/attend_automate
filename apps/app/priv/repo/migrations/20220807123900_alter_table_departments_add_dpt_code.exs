defmodule App.Repo.Migrations.AlterTableDepartmentsAddDptCode do
  use App.Migration

  def change do
    alter table(:departments) do
      add :dpt_code, :string, [min: 2, max: 3, null: false]
    end
  end
end
