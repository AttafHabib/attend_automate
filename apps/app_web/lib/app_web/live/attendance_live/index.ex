defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context
  alias App.Context.{Users, Students, Attendances, CourseOffers}

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
    attendance_data = get_attendance_data(id)

    IO.inspect("=============action=============")
    IO.inspect(action)
    IO.inspect("=============action=============")

#    if connected?(socket), do: Process.send_after(self(), "draw_chart", 300)


    {:noreply,
      socket
      |> assign(tab_action: action)
      |> assign(action_id: id)
      |> assign(attendance_data: attendance_data)
#      |> assign(dataset: draw_pichart(enc_attend))
    }
  end

  @impl true
  def handle_event("filter_attend", %{"_target" => ["month"], "month" => ""}=params, socket) do
    attendance_data = get_attendance_data(socket.assigns.action_id)
    {:noreply,
      socket
      |> assign(attendance_data: attendance_data)
    }
  end
  
  @impl true
  def handle_event("filter_attend", %{"_target" => ["month"], "month" => date}=params, socket) do
    [year, month] = String.split(date, "-")
    attendance_data = get_attendance_data(socket.assigns.action_id, String.to_integer(month))

    {:noreply,
      socket
      |> assign(attendance_data: attendance_data)
    }
  end

  def draw_pichart(dataset) do
    dataset
    |> Contex.Dataset.new(["Type", "Value"])
    |> Contex.PieChart.new([
      mapping: %{category_col: "Type", value_col: "Value"},
      data_labels: true,
      colour_palette: ["E15A5A", "508CDA"]
    ])|>IO.inspect
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

#  @impl true
#  def handle_info("draw_chart", socket) do
#    {
#      :noreply,
#      push_event(
#        socket,
#        "draw_chart",
#        %{"chart_data" => socket.assigns.chart_data}
#      )
#    }
#  end


  def get_attendance_data(s_course_id, month \\ nil) do
    c_offer = CourseOffers.get_by_s_course_id(s_course_id)
    start_date = get_date(c_offer.start_date)
    end_date = get_date(c_offer.end_date)

    attendances = Attendances.get_by_s_course(s_course_id, month)
    attend = Enum.frequencies_by(attendances, &(&1.status && "Present" || "Absent"))

    present_per = attend
    pr = attend["Present"] || 0
    ab = attend["Absent"] || 0

    total = pr + ab
    perc = (((total != 0) && (pr/total) || 0.0) * 100) |> Float.round(2)
    attendance_data = %{
      total: total,
      perc: perc,
      pr: pr,
      ab: ab,
      start_date: start_date,
      end_date: end_date,
      data: attendances
    }
  end

  def get_date(date) do
    {year, month} = {date.year, date.month}
    month = if(month < 10) do "0" <> "#{month}" else month end
    "#{year}-#{month}"
  end
end