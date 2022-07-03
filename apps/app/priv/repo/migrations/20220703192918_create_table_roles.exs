defmodule App.Repo.Migrations.CreateTableRoles do
  use App.Migration

  @table :roles
  def change do
    create table(@table) do
      add :name, :string, null: false
      timestamp()
    end
    create unique_index(@table, [:name])
  end
end
