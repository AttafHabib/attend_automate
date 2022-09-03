defmodule AppWeb.StudentLive.CourseComponent do
  use AppWeb, :live_component
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files, Courses}
  alias App.Schema.{Student, StudentCourse, File, Course}
  alias AppWeb.Utils.ClientHelper

  def update(%{student_id: id}, socket) do
    student = Students.get_student!(id)
              |> Context.preload_selective([:user, :face_images, courses: :department])

    {
      :ok,
      socket
      |> assign(student: student)
    }
  end

  @impl true
  def handle_event("save", %{"course_offer" => %{"course_offer_id" => id} = params}, socket) do
    params = Map.put(params, "student_id", socket.assigns.student.id)
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")

    case Context.create(StudentCourse, params) do
      {:ok, course} -> student = Students.get_student!(id)
                                 |> Context.preload_selective([:user, :face_images, courses: :department])

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
end