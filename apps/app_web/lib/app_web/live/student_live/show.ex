defmodule AppWeb.StudentLive.Show do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Context
  alias App.Context.{Students}
  alias App.Schema.{Student}

  def mount(%{"id" => id}, session, socket) do
    student = Students.get_student!(id)

    {
      :ok,
      socket
      |> assign(:student, student)
    }
  end
end