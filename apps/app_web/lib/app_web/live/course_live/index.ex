defmodule AppWeb.CourseLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Schema.{Course, Department}
  alias App.Context
  alias App.Context.{Users, Courses, Students}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->
#        courses= assign_courses(user)

#        Enum.map(courses, fn course ->
#          Enum.join(Enum.map(course.teachers, &(&1.first_name <> " " <> &1.last_name)), ", ")|> IO.inspect()
#        end)

        {
          :ok,
          socket
          |> assign(user: user)
          |> assign_courses()

        }

      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
    end
  end

  @impl true
  def handle_event("search_bar", _, socket) do
    socket = if(socket.assigns[:search_bar]) do
      socket
      |> assign(courses: socket.assigns.all_courses)
      |> assign(search_value: "")
    else
      socket
    end

    {
      :noreply,
      socket
      |> assign(:search_bar, !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("search", %{"value" => value} = params, socket) do
    courses = Enum.filter(socket.assigns.all_courses, fn course ->
      course.name
      |> String.downcase()
      |> String.contains?(String.downcase(value))
    end)

    {
      :noreply,
      socket
      |> assign(courses: courses)
      |> assign(search_value: value)
    }
  end

  @impl true
  def handle_event("save", %{"course" => params}, socket) do
    case Context.create(Course, params) do
      {:ok, dpt} ->
        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

        courses = Context.list(Course) |> Context.preload_selective([:department, :students, :teachers])
        {
          :noreply,
          socket
          |> assign(courses: courses)
        }
      {:error, changeset_} -> {:noreply, socket}

    end

  end

  @impl true
  def handle_event("show_course", %{"id" => id}, socket) do
    {:noreply,
      socket
      |> push_redirect(to: Routes.course_show_path(socket, :show, id))
    }
  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    changeset_course = Context.change(Course, %Course{})
    dpt_dropdown = Context.list_dropdown(Department, :name)

    {
      :noreply,
      socket
      |> assign(modal: modal)
      |> assign(changeset_course: changeset_course)
      |> assign(dpt_dropdown: dpt_dropdown)
    }
  end

  @impl true
  def handle_event("close_modals", _, socket) do
    if connected?(socket), do: Process.send_after(self(), "close_modals", 100)

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
      )    }
  end

  def assign_courses(%{assigns: %{user: user}}=socket) do
    courses = cond do
      user.user_role.role_id ==1 -> courses = Context.list(Course)
                                                    |> Context.preload_selective([:department, :students, :teachers])

      user.user_role.role_id == 3 -> teacher=  App.Context.Teachers.get_by_user_id(user.id)
                                     courses=  Courses.get_by_teacher_id(teacher.id)
                                               |> Enum.map(fn course ->
                                                  c_offers = App.Context.CourseOffers.get_by_course(course.id)
                                                  Map.put(course, :students, c_offers.student_courses)
                                                end)
      user.user_role.role_id == 2 -> student = Students.get_by_user_id(user.id)
                                     courses = Courses.get_by_student_id(student.id)
      true -> []
    end
    socket
    |> assign(courses: courses)
    |> assign(all_courses: courses)
  end

end