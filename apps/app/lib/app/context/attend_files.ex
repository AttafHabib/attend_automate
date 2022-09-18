defmodule App.Context.AttendFiles do
  @moduledoc """
  The Context.AttendFiles context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Schema.AttendFile



  def get_one(c_offer_id, date) do
    from(at in AttendFile,
      where: at.date == ^date and at.course_offer_id == ^c_offer_id
    ) |> Repo.one

  end


end