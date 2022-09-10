defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context
  alias App.Context.{Users, Students, Attendances}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->

        {:ok,
          socket
          |> assign(user: user)
#          |> assign(tab_action: "report")
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
  def handle_event("tab", %{"action" => action, "id" => id}, socket) do
    attendances = Attendances.get_by_s_course(id)
    enc_attend = Enum.frequencies_by(attendances, &(&1.status && "Present" || "Absent"))
                 |> Enum.into []
    IO.inspect("=============enc_attend=============")
    IO.inspect(enc_attend)
    IO.inspect("=============enc_attend=============")

    
    {:noreply,
      socket
      |> assign(tab_action: action)
      |> assign(enc_attend: enc_attend)
      |> assign(dataset: draw_pichart(enc_attend))
    }
  end

  def draw_pichart(dataset) do
    dataset
    |> Contex.Dataset.new(["Type", "Value"])
    |> Contex.PieChart.new([
      mapping: %{category_col: "Type", value_col: "Value"},
      data_labels: true
    ])
    |> Contex.PieChart.to_svg()
  end

  @impl true
  def handle_event("get_face", _, socket) do
#    port = Port.open(
#      {:spawn, "python3 main.py"},
#      [:binary, :nouse_stdio, {:packet, 4}]
#    )

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