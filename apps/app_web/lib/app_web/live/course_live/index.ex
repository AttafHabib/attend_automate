defmodule AppWeb.CourseLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers

  def mount(params, session, socket) do
    IO.inspect session
    courses = get_random_courses()
    user = Helpers.get_current_user(session["guardian_default_token"])

    {
      :ok,
      socket
      |> assign(:courses, courses)
      |> assign(:user, user)
    }
  end

  defp get_random_courses() do
    Enum.map(1..10, fn x ->
#      {:ok, d} = DateTime.now "Etc/UTC"
      Map.new([title: "Course #{x}",
        teacher: "Teacher #{x}",
        code: "C" <> Enum.random(["C", "X", "A", "T"]) <> "#{Enum.random 1..9}",
        id: x])
    end)
  end


end