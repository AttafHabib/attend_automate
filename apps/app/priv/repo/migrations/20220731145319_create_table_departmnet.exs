defmodule App.Repo.Migrations.CreateTableDepartmnet do
  use App.Migration

  @table :departments
  def change do
    create table(@table) do
      add :name, :string

      timestamp()
    end

  end
end
