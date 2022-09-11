defmodule App.Repo.Migrations.AlterTableCourseOffersAddStartEndDate do
  use Ecto.Migration

  def change do
    alter table(:course_offers) do
      add :start_date, :date
      add :end_date, :date
    end
  end
end
