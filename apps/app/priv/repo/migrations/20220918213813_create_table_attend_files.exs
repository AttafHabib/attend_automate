defmodule App.Repo.Migrations.CreateTableAttendFiles do
  use Ecto.Migration

  def change do
    create table(:attend_files) do
      add :course_offer_id, references(:course_offers)
      add :date, :date
      add :path, :string

      timestamps()
    end
  end
end
