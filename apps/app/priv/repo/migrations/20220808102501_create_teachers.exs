defmodule App.Repo.Migrations.CreateTeachers do
  use App.Migration

  def change do
    create table(:teachers) do
      add :first_name, :string, [size: 30, null: false]
      add :last_name, :string, [size: 30]
      add :email, :string
      add :cnic, :string, [size: 13, null: false]
      add :address, :string, [null: false]
      add :phone_no, :string, [null: false]

      add :user_id, references(:users, on_delete: :nothing)
      add :department_id, references(:departments, on_delete: :delete_all)

      timestamp()
    end

    create unique_index(:teachers, [:cnic])
  end
end
