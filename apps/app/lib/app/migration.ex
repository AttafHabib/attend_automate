defmodule App.Migration do

  defmacro __using__(_opts) do
    quote do
      use Ecto.Migration

      def timestamp do
        add :deleted_at, :utc_datetime
        timestamps()
      end
    end
  end
end