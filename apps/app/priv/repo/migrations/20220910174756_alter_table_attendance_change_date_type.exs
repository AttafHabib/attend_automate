defmodule App.Repo.Migrations.AlterTableAttendanceChangeDateType do
  use Ecto.Migration

  def change do
    alter table(:attendances) do
      remove :date
      add :date, :date
    end

  end
end
