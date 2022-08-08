defmodule AppWeb.StudentLive.Index do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students}
  alias App.Schema.{Student}

  def mount(params, session, socket) do
    students = Students.list_students

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

    changeset_student = Context.change(Student, %Student{})
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
  def handle_event("save", params, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")
    {:noreply, socket}
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
      assign(socket, :modal, nil)
      #      push_event(
      #        assign(socket, :modal, nil),
      #        "close_modals",
      #        %{"modal" => socket.assigns.modal}
      #      )
    }
  end
end