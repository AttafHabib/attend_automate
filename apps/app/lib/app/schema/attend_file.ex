defmodule App.Schema.AttendFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attend_files" do
    field :date, :date
    field :path, :string


    belongs_to(:course_offer, App.Schema.CourseOffer)

    timestamps()
  end

  @doc false
  def changeset(attendance, attrs) do
    attendance
    |> cast(attrs, [:path, :date, :course_offer_id])
    |> validate_required([:path, :date, :course_offer_id])
  end
end
