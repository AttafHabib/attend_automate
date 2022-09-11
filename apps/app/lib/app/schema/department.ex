defmodule App.Schema.Department do
  use App.Schema
  import Ecto.Changeset

  schema "departments" do
    field :name, :string
    field :dpt_code, :string

    timestamp()

    has_many(:students, App.Schema.Student)
    has_many(:courses, App.Schema.Course)
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:name, :dpt_code])
    |> validate_required([:name, :dpt_code])
    |> validate_length(:dpt_code, min: 2, max: 3)
  end
end
