defmodule App.Repo.Migrations.CreateTableUsers do
  use App.Migration

  @table :users
  def change do
    create table(@table) do
      add :username, :string, [size: 30, null: false]
      add :email, :string,  null: false
      add :cnic, :string, [size: 13,  null: false]
      add :password, :string,  null: false
      timestamp()
    end
    create unique_index(@table, [:email, :cnic])
  end
end
