defmodule AppWeb.StudentLive.CourseComponent do
  use AppWeb, :live_component
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files, Courses}
  alias App.Schema.{Student, StudentCourse, File, Course}
  alias AppWeb.Utils.ClientHelper

  def update(%{student_id: id}, socket) do
    student = Students.get_student!(id)
              |> Context.preload_selective([:user, :face_images, :department, [s_courses: [:attendances, course_offer: :course]]])

    {
      :ok,
      socket
      |> assign(student: student)
    }
  end

  @impl true
  def handle_event("save", %{"course_offer" => %{"course_offer_id" => _id} = params}, socket) do
    params = Map.put(params, "student_id", socket.assigns.student.id)

    case Context.create(StudentCourse, params) do
      {:ok, course} -> student = Students.get_student!(socket.assigns.student.id)
                                 |> Context.preload_selective([:user, :face_images, :department, [s_courses: [:attendances, course_offer: :course]]])

                       if connected?(socket), do: Process.send_after(self(), "close_modals_" <> socket.assigns.modal, 300)
                       {
                         :noreply,
                         socket
                         |> assign(student: student)
                       }
      {:error, changeset} -> IO.inspect("=============changeset=============")
                             IO.inspect(changeset)
                             IO.inspect("=============changeset=============")

                             if connected?(socket), do: Process.send_after(self(), "close_modals_" <> socket.assigns.modal, 300)

                             {:noreply, socket}
    end
  end

  @impl true
  def handle_event("open_modals", %{"modal" => "add_course" = modal}, socket) do
    c_dropdown = Courses.get_course_offers(socket.assigns.student.id, socket.assigns.student.department_id)
                 |> Context.list_dropdown([:name])

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

  def get_attendance(s_course) do
    freq = Enum.frequencies_by(s_course.attendances, &(&1.status))
    p = freq[:true] || 0
    a = freq[:false] || 0
    total = p + a
    perc = (total != 0) && (p/total) || 0
    {p, total, perc}
  end
end