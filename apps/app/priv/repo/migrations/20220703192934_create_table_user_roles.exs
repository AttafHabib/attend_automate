defmodule App.Repo.Migrations.CreateTableUserRoles do
  use App.Migration

  @table :user_roles
  def change do
    create table(@table) do
      add :user_id, references(:users)
      add :role_id, references(:roles)
      timestamp()
    end
  end
end
