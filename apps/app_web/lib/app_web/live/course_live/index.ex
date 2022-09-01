defmodule AppWeb.CourseLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Schema.{Course, Department}
  alias App.Context

  def mount(params, session, socket) do
    courses = Context.list(Course)
              |> Context.preload_selective([:department, :students, :teachers])

    Enum.map(courses, fn course ->
    Enum.join(Enum.map(course.teachers, &(&1.first_name <> " " <> &1.last_name)), ", ")|> IO.inspect()
                                      end)
    user = Helpers.get_current_user(session["guardian_default_token"])

    {
      :ok,
      socket
      |> assign(:courses, courses)
      |> assign(:user, user)
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
  def handle_event("search", %{"value" => search_string} = params, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("save", %{"course" => params}, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")

    case Context.create(Course, params) do
      {:ok, dpt} ->
        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

        courses = Context.list(Course) |> Context.preload_selective([:department, :students, :teachers])
        {
          :noreply,
          socket
          |> assign(:courses, courses)
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
      |> assign(:modal, modal)
      |> assign(:changeset_course, changeset_course)
      |> assign(:dpt_dropdown, dpt_dropdown)
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

end