defmodule App.Schema do

  defmacro __using__(__opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import App.Schema

      @timestamps_opts [type: :utc_datetime]
    end
  end

  defmacro timestamp() do
    quote do
      field :deleted_at, :utc_datetime
      timestamps()
    end
  end
end