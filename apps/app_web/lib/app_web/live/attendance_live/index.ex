defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context
  alias App.Context.{Users, Students}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->

        {:ok,
          socket
          |> assign(user: user)
          |> assign(tab_action: "report")
          |> load_role()
        }

      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
    end
  end

  def load_role(socket) do
    user = socket.assigns.user
    case user.user_role.role_id do
      1 -> socket
      2 ->
          student = Students.get_by_user_id(user.id)
                    |> Context.preload_selective([:department, s_courses: [course_offer: :course]])
          socket
          |> assign(student: student)
      2 -> socket
      3 -> socket
      4 -> socket
    end
  end

  @impl true
  def handle_event("tab", %{"action" => action}, socket) do
    {:noreply,
      socket
      |> assign(tab_action: action)
    }
  end

  @impl true
  def handle_event("get_face", _, socket) do
    port = Port.open(
      {:spawn, "python3 main.py"},
      [:binary, :nouse_stdio, {:packet, 4}]
    )

    {
      :noreply,
      socket
      |> assign(action: :get_face)
    }
  end

#  @impl true
#  def handle_event("open_modals", %{"modal" => modal}, socket) do
#    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)
#
#    {
#      :noreply,
#      socket
#      |> assign(:modal, modal)
#    }
#  end
end