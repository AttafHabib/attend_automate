defmodule App.Schema.File do
  use App.Schema
  import Ecto.Changeset

  schema "files" do
    field :path, :string
    field :mime, :string, default: "image/png"
    field :tag, :string


    belongs_to :user, App.Schema.User

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:path, :mime, :tag, :user_id])
    |> validate_required([:path, :tag, :user_id])
  end
end
