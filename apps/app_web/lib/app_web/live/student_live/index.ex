defmodule AppWeb.StudentLive.Index do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students, CourseOffers}
  alias App.Schema.{Student, Department}

  def mount(params, session, socket) do
    students = Students.list_students
               |> Context.preload_selective([:department, [s_courses: [course_offer: :course]]])

    {:ok,
      socket
      |> assign(:students, students)
    }
  end

  @impl true
  def handle_event("search_bar", _, socket) do
    {
      :noreply,
      socket
      |> assign(:search_bar, !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    student = %Student{} |> Context.preload_selective([:student_courses])

    changeset_student = Context.change(Student, student)
    dpt_dropdown = Context.list_dropdown(Department, :name)


    {
      :noreply,
      socket
      |> assign(:modal, modal)
      |> assign(:changeset_student, changeset_student)
      |> assign(:dpt_dropdown, dpt_dropdown)
    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["student", "department_id"], "student" => %{"department_id" => ""}}, socket)   do
    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
    {
      :noreply,
      socket
      |> assign(:course_dropdown, nil)
    }
  end
  
  @impl true
  def handle_event("validate", %{"_target" => ["student", "department_id"], "student" => params}, socket) do
    course_dropdown = CourseOffers.list_dropdown(params["department_id"])

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {
      :noreply,
      socket
      |> assign(:course_dropdown, course_dropdown)
    }
  end
  
  @impl true
  def handle_event("save", %{"student" => params}, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")

    l_student = Context.get_last(Student)
    roll_no = l_student && (l_student.id ++ 1) || 1

    params = Map.put(params, "roll_no", "#{roll_no}")

    case Context.create(Student, params) do
      {:ok, student} -> params_ = params["student_courses"]
                                  |> Enum.map(&(%{"course_offer_id" => &1, "student_id" => student.id}))

                        params = Map.put(params, "student_courses", params_)
                        Students.add_s_courses(student, params)

                        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

                        students = Students.list_students
                                   |> Context.preload_selective()

                        {:ok,
                          socket
                          |> assign(:students, students)
                        }
      {:error, changeset} ->
        IO.inspect("=============changeset=============")
        IO.inspect(changeset)
        IO.inspect("=============changeset=============")
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("show_student", %{"id" => id}, socket) do

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.student_show_path(socket, :show, id))
    }
  end

  @impl true
  def handle_event("close_modals", _, socket) do
    if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info("open_modals", socket) do
    {
      :noreply,
      push_event(
        socket,
        "open_modals",
        %{"modal" => socket.assigns.modal}
      )
    }
  end

  @impl true
  def handle_info("close_modals", socket) do
    {
      :noreply,
      push_event(
        socket,
        "close_modals",
        %{"modal" => socket.assigns.modal}
      )
    }
  end

  @impl true
  def handle_info("display_modals", socket) do
    {
      :noreply,
      push_event(
        socket,
        "display_modals",
        %{"modal" => socket.assigns.modal}
      )
    }
  end
end