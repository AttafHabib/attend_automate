defmodule App.Repo.Migrations.CreateTableStudents do
  use App.Migration

  @table :students
  def change do
    create table(@table) do
      add :first_name, :string, [size: 30, null: false]
      add :last_name, :string,[size: 30]
      add :email, :string
      add :roll_no, :string, [null: false]
      add :cnic, :string, [size: 13, null: false]
      add :address, :string, [null: false]
      add :phone_no, :string, [null: false]
      add :user_id, references(:users, on_delete: :nothing)

      timestamp()
    end
    create unique_index(@table, [:cnic, :roll_no])
  end
end
