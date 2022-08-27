defmodule App.Schema.File do
  use App.Schema
  import Ecto.Changeset

  schema "files" do
    field :path, :string
    field :mime, :string

    timestamp()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:path, :mime])
    |> validate_required([:path])
  end
end
