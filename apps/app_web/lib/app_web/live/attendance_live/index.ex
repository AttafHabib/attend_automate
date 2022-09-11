defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context
  alias App.Context.{Users, Students, Attendances, CourseOffers, Teachers}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->

        {:ok,
          socket
          |> assign(user: user)
          |> assign(filter_params: %{})
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
          |> assign(show_attendance: true)
      3 -> teacher = Teachers.get_by_user_id(user.id)
                     |> Context.preload_selective([:department, course_offers: :course])

           course_offer = teacher.course_offers
                          |> List.first
                          |> Context.preload_selective([student_courses: :student])

           student_dropdown = Enum.map(course_offer.student_courses, fn s_course ->
             student = s_course.student
             {"#{student.first_name} #{student.last_name} - #{student.roll_no}", s_course.id}
           end)

           socket
           |> assign(teacher: teacher)
           |> assign(student_dropdown: student_dropdown)
           |> assign(tab_action: course_offer.course.name)
           |> assign(action_id: course_offer.course.id)
           |> assign(attendance_data: %{})
           |> assign(filter_params: %{})
           |> assign(show_attendance: false)
      4 -> socket
    end
  end

  @impl true
  def handle_event("tab", %{"action" => action, "id" => id, "type" => type}=params, socket) do
    socket = case type do
      "teacher" -> course_offers = CourseOffers.get_by_course(id)
                                   |> Context.preload_selective([student_courses: :student])
                   student_dropdown = Enum.map(course_offers.student_courses, fn s_course ->
                     student = s_course.student
                     {"#{student.first_name} #{student.last_name} - #{student.roll_no}", s_course.id}
                   end)

                   socket
                   |> assign(student_dropdown: student_dropdown)
                   |> assign(attendance_data: %{})
                   |> assign(show_attendance: false)
                   |> assign(filter_params: %{})

      "student" -> filter_params = Map.put(socket.assigns.filter_params, :student, id)
                   attendance_data = CourseOffers.get_by_s_course_id(id)
                                     |> map_attendances(filter_params)

                    socket
                    |> assign(attendance_data: attendance_data)
                    |> assign(filter_params: filter_params)
                    |> assign(show_attendance: true)
    end

    {:noreply,
      socket
      |> assign(tab_action: action)
      |> assign(action_id: id)
    }
  end

  @impl true
  def handle_event("filter_attend", %{"student" => ""}, socket) do
    filter_params = socket.assigns.filter_params
                    |> Map.delete(:student)

    {:noreply,
      socket
      |> assign(show_attendance: false)
      |> assign(attendance_data: %{})
      |> assign(filter_params: %{})
    }
  end
  
  @impl true
  def handle_event("filter_attend", %{"student" => s_courses_id}, socket) do
    filter_params = socket.assigns.filter_params
                    |> Map.put(:student, s_courses_id)

    course_offers = CourseOffers.get_by_course(socket.assigns.action_id)
                    |> Context.preload_selective([student_courses: :student])

    attendance_data = map_attendances(course_offers, filter_params)

    {
      :noreply,
      socket
      |> assign(attendance_data: attendance_data)
      |> assign(filter_params: filter_params)
      |> assign(show_attendance: true)
    }
  end

  
  @impl true
  def handle_event("filter_attend", %{"_target" => ["month"], "month" => date}=params, socket) do
    filter_params = if(date == "") do
      socket.assigns.filter_params
      |> Map.delete(:month)
    else
      [year, month] = String.split(date, "-")
      socket.assigns.filter_params
      |> Map.put(:month, String.to_integer(month))
    end

    attendance_data = case socket.assigns.user.user_role.role_id do
      1 -> ""

      2 ->  socket.assigns.action_id
            |> CourseOffers.get_by_s_course_id()
            |> map_attendances(filter_params)

      3 -> if(socket.assigns.show_attendance) do
             socket.assigns.action_id
             |> CourseOffers.get_by_course()
             |> Context.preload_selective([student_courses: :student])
             |> map_attendances(filter_params)
           end || %{}
    end

    {:noreply,
      socket
      |> assign(attendance_data: attendance_data)
      |> assign(filter_params: filter_params)
    }
  end

#  def draw_pichart(dataset) do
#    dataset
#    |> Contex.Dataset.new(["Type", "Value"])
#    |> Contex.PieChart.new([
#      mapping: %{category_col: "Type", value_col: "Value"},
#      data_labels: true,
#      colour_palette: ["E15A5A", "508CDA"]
#    ])|>IO.inspect
#    |> Contex.PieChart.to_svg()
#  end

#  @impl true
#  def handle_event("get_face", _, socket) do
##    port = Port.open(
##      {:spawn, "python3 main.py"},
##      [:binary, :nouse_stdio, {:packet, 4}]
##    )
#
#    {
#      :noreply,
#      socket
#      |> assign(action: :get_face)
#    }
#  end

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

#  def get_attendance_data(c_offer_id, "teacher", month) do
#    c_offer = CourseOffers.get_by_course(c_offer_id)
#
#    s_courses_ids = Enum.map(c_offer.student_courses, &(&1.id))
#
#    map_attendances(c_offer, s_courses_ids, month)
#  end


#  def get_attendance_data(s_course_id, "student", month) do
#    c_offer = CourseOffers.get_by_s_course_id(s_course_id)
#
#    map_attendances(c_offer, s_course_id, month)
#  end

  # s_course_ids can be list or single id
  def map_attendances(c_offer, filter_params) do
    s_course_ids = filter_params[:student]
    month = filter_params[:month]

    start_date = get_date(c_offer.start_date)
    end_date = get_date(c_offer.end_date)

    attendances = Attendances.get_by_s_course(s_course_ids, month)

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