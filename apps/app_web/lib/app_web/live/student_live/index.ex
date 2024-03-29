defmodule AppWeb.StudentLive.Index do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students, CourseOffers, Users}
  alias App.Schema.{Student, Department}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} -> case user.user_role.role_id in [1] do
                       true -> students = Students.list_students
                                                   |> Context.preload_selective([:department, [s_courses: [course_offer: :course]]])
                                        {:ok,
                                          socket
                                          |> assign(user: user)
                                          |> assign(students: students)
                                          |> assign(all_students: students)
                                        }
                       _ -> {:ok, push_redirect(socket, to: "/dashboard")}
                     end

      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
    end
  end

  @impl true
  def handle_event("search_bar", _, socket) do
    socket = if(socket.assigns[:search_bar]) do
      socket
      |> assign(students: socket.assigns.all_students)
      |> assign(search_value: "")
    else
      socket
    end

    {
      :noreply,
      socket
      |> assign(search_bar: !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    student = %Student{}

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
  def handle_event("search", %{"value" => value}, socket) do
    students = Enum.filter(
      socket.assigns.all_students,
      fn student ->
        String.contains?(
          String.downcase(student.first_name) <> " " <> String.downcase(student.last_name),
          String.downcase(value)
        )
      end
    )


    {
      :noreply,
      socket
      |> assign(students: students)
      |> assign(search_value: value)
    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["student", "department_id"], "student" => %{"department_id" => ""}}, socket)   do
    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
    {
      :noreply,
      socket
      |> assign(course_dropdown: nil)
    }
  end
  
  @impl true
  def handle_event("validate", %{"_target" => ["student", "department_id"], "student" => params}, socket) do
    course_dropdown = CourseOffers.list_dropdown(params["department_id"])

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {
      :noreply,
      socket
      |> assign(course_dropdown: course_dropdown)
    }
  end
  
  @impl true
  def handle_event("save", %{"student" => params}, socket) do
    l_student = Context.get_last(Student)
    roll_no = l_student && (String.to_integer(l_student.roll_no) + 1) || 1

    params = Map.put(params, "roll_no", "#{roll_no}")

    case Context.create(Student, params) do
      {:ok, student} ->
#        params_ = params["student_courses"]
#                                  |> Enum.map(&(%{"course_offer_id" => &1, "student_id" => student.id}))

#                        params = Map.put(params, "student_courses", params_)
                        for co_id <- params["student_courses"] do
                          case Context.create(App.Schema.StudentCourse, %{student_id: "#{student.id}", course_offer_id: co_id}) do
                            {:ok, _} -> ""
                            {:error, changeset} -> IO.inspect("=============error=============")
                                                   IO.inspect(changeset)
                                                   IO.inspect("=============error=============")
                          end
                        end

                        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

                        students = Students.list_students
                                   |> Context.preload_selective([:department, [s_courses: [course_offer: :course]]])

                        {:noreply,
                          socket
                          |> assign(students: students)
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