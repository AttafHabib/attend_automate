defmodule App.Repo.Migrations.CreateTableFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add(:path, :string)
      add(:mime, :string)
      add(:tag, :string)

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
