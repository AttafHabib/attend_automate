defmodule AppWeb.StudentLive.CourseComponent do
  use AppWeb, :live_component
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files, Courses}
  alias App.Schema.{Student, File, Course}
  alias AppWeb.Utils.ClientHelper

  def update(%{student_id: id}, socket) do
    student = Students.get_student!(id)
              |> Context.preload_selective([:user, :face_images, :courses]) |> IO.inspect()

    courses = Context.list(Course) |> Context.preload_selective([:department, :students])


    {
      :ok,
      socket
      |> assign(student: student)
      |> assign(courses: courses)
    }
  end

  @impl true
  def handle_event("save", %{"course" => params}, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")

    if connected?(socket), do: Process.send_after(self(), "close_modals_" <> socket.assigns.modal, 300)

    {:noreply, socket}
  end

  @impl true
  def handle_event("open_modals", %{"modal" => "add_course" = modal}, socket) do
    c_dropdown = Courses.get_offered_courses(socket.assigns.student.id, socket.assigns.student.department_id)
                 |> Context.list_dropdown([:name, :course_code])

    if connected?(socket), do: Process.send_after(self(), "open_modals_" <> modal, 300)

    {
      :noreply,
      socket
      |> assign(course_dropdown: c_dropdown)
      |> assign(modal: modal)
    }
  end

  @impl true
  def handle_event("close_modals", _, socket) do
    if connected?(socket), do: Process.send_after(self(), "close_modals_" <> socket.assigns.modal, 300)

    {
      :noreply,
      socket
    }
  end
end