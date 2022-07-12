defmodule App.Repo.Migrations.CreateTableUserRoles do
  use App.Migration

  @table :user_roles
  def change do
    create table(@table) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)
      timestamp()
    end
  end
end
