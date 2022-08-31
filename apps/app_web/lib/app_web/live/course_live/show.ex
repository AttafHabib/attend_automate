defmodule AppWeb.CourseLive.Show do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Schema.{Course, Department}
  alias App.Context


  def mount(%{"id" => id}, _session, socket) do
    course = Context.get(Course, id) |> Context.preload_selective([:department, :students])

    {
      :ok,
      socket
      |> assign(:course, course)
    }
  end
end