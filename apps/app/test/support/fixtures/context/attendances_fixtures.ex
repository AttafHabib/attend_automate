defmodule App.Context.AttendancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.Attendances` context.
  """

  @doc """
  Generate a attendance.
  """
  def attendance_fixture(attrs \\ %{}) do
    {:ok, attendance} =
      attrs
      |> Enum.into(%{
        date: "some date",
        status: true
      })
      |> App.Context.Attendances.create_attendance()

    attendance
  end
end
