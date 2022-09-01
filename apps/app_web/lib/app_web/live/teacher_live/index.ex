defmodule AppWeb.TeacherLive.Index do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Teachers}
  alias App.Schema.{Teacher, Department, Course}

  def mount(params, session, socket) do
    teachers = Context.list(Teacher)
               |> Context.preload_selective([:department, :courses])

    {:ok,
      socket
      |> assign(:teachers, teachers)
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

    teacher = %Teacher{}
              |> Context.preload_selective([:course_offers])
    changeset_teacher = Context.change(Teacher, teacher)
    dpt_dropdown = Context.list_dropdown(Department, :name)
    cour_dropdown = Context.list_dropdown(Course, :name)


    {
      :noreply,
      socket
      |> assign(:modal, modal)
      |> assign(:changeset_teacher, changeset_teacher)
      |> assign(:dpt_dropdown, dpt_dropdown)
      |> assign(:cour_dropdown, cour_dropdown)
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
  def handle_event("save", %{"teacher" => params}, socket) do
    case Context.create(Teacher, params) do
      {:ok, teacher} -> params_ = params["course_offers"]
                                 |> Enum.map(&(%{"course_id" => &1, "teacher_id" => teacher.id}))

                        params = Map.put(params, "course_offers", params_)
                        Teachers.add_courses(teacher, params)

                        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

                        teachers = Context.list(Teacher)
                                   |> Context.preload_selective([:department, :courses])

                        {:noreply,
                          socket
                          |> assign(:teachers, teachers)
                        }
      {:error_changeset} -> {:noreply, socket}
    end
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
end