defmodule AppWeb.StudentLive.Show do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Context
  alias App.Context.{Students}
  alias App.Schema.{Student}

  def mount(%{"id" => id}, session, socket) do
    student = Students.get_student!(id) |> Context.preload_selective([:department, :courses])

    {
      :ok,
      socket
      |> assign(:student, student)
      |> assign(:tab_action, "attendance")
    }
  end

  @impl true
  def handle_event("tab", %{"action" => action}, socket) do
    {:noreply,
      socket
      |> assign(tab_action: action)
    }
  end

  @impl true
  def handle_info("open_modals_" <> modal, socket) do
    {
      :noreply,
      push_event(
        socket,
        "open_modals",
        %{"modal" => modal}
      )
    }
  end

  @impl true
  def handle_info("close_modals_" <> modal, socket) do
    {
      :noreply,
      push_event(
        socket,
        "close_modals",
        %{"modal" => modal}
      )
    }
  end
end