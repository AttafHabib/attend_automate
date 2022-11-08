defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context
  alias App.Context.{Users, Students, Attendances, CourseOffers, Teachers, StudentCourses}

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->

        {:ok,
          socket
          |> assign(user: user)
          |> assign(filter_params: %{})
            #          |> assign(tab_action: "report")
          |> load_role()
          |> assign_action()
        }

      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
    end
  end

  def assign_action(socket) do
    case socket.assigns.user.user_role.id do
      3 ->
        t_course = List.first(socket.assigns.teacher.course_offers)
        course_offer = CourseOffers.get_by_course(t_course.id)
                       |> Context.preload_selective([student_courses: :student])
        student_dropdown = Enum.map(course_offer.student_courses, fn s_course ->
          student = s_course.student
          {"#{student.first_name} #{student.last_name} - #{student.roll_no}", s_course.id}
        end)

        socket
        |> assign(student_dropdown: student_dropdown)
        |> assign(course_offer: course_offer)
        |> assign(attendance_data: %{})
        |> assign(show_attendance: false)
        |> assign(filter_params: %{})
        |> assign(tab_action: t_course.name)
        |> assign(action_id: t_course.id)
      2 ->
        s_course = List.first(socket.assigns.student.s_courses)
        filter_params = Map.put(socket.assigns.filter_params, :student, s_course.id)
        attendance_data = CourseOffers.get_by_s_course_id(s_course.id)
                          |> map_attendances(filter_params)

        socket
        |> assign(attendance_data: attendance_data)
        |> assign(filter_params: filter_params)
        |> assign(show_attendance: true)
        |> assign(tab_action: s_course.course_offer.course.name)
        |> assign(action_id: s_course.id)
      _ -> socket
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
           |> assign(course_offer: course_offer)
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
      "teacher" -> course_offer = CourseOffers.get_by_course(id)
                                   |> Context.preload_selective([student_courses: :student])
                   student_dropdown = Enum.map(course_offer.student_courses, fn s_course ->
                     student = s_course.student
                     {"#{student.first_name} #{student.last_name} - #{student.roll_no}", s_course.id}
                   end)

                   socket
                   |> assign(student_dropdown: student_dropdown)
                   |> assign(course_offer: course_offer)
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

  @impl true
  def handle_event("update_attendance", %{"_target" => ["auto", "date"], "auto" => %{"date" => date}}=params, socket) do
    IO.inspect("==========================")
    IO.inspect(params)
    IO.inspect("==========================")
    Process.sleep(2000)

    socket = case AppWeb.Utils.ClientHelper.recognize_faces() do
      {:ok, %{"file_name" => file_name, "recognized_ids" => user_ids}} ->
        mark_auto_attendance(user_ids, date, socket)
        attendance_data = socket.assigns.course_offer
                          |> get_attendance_data()
                          |> Enum.map(
                               fn c_offer -> if("#{c_offer.user_id}" in user_ids) do
                                               Map.put(c_offer, :attendance, true)
                                             else
                                               c_offer
                                             end
                               end)

        current_file = App.Context.AttendFiles.get_one(socket.assigns.course_offer.id, date)
        {:ok, attend_file} = if(current_file) do
          IO.inspect("=============current_file=============")
          IO.inspect(file_name)
          IO.inspect(current_file)
          IO.inspect("=============current_file=============")
          Context.update(App.Schema.AttendFile, current_file, %{path: "uploads/#{file_name}"})
        else
          file_params = %{
            path: "uploads/#{file_name}",
            course_offer_id: socket.assigns.course_offer.id,
            date: date
          }
          Context.create(App.Schema.AttendFile, file_params)
        end


        IO.inspect("=============user_ids=============")
        IO.inspect(user_ids)
        IO.inspect("=============user_ids=============")

        socket
        |> assign(c_students: attendance_data)
        |> assign(attend_file: attend_file)
      {:error, reason} ->
        IO.inspect("=============error=============")
        IO.inspect(reason)
        IO.inspect("=============error=============")
        socket
    end

    IO.inspect("=============socket.assigns.c_studnets=============")
    IO.inspect(socket.assigns.c_students)
    IO.inspect("=============socket.assigns.c_studnets=============")

    date_data = socket.assigns.date_data
                |> Map.put(:selected_date, date)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {
      :noreply,
      socket
      |> assign(date_data: date_data)
    }
  end

  @impl true
  def handle_event("mark_attendance", %{"type" => "auto"=type}, socket) do
    date_data = get_date_data(socket.assigns.course_offer)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {
      :noreply,
      socket
      |> assign(attendance_type: type)
      |> assign(date_data: date_data)
      |> assign(attend_file: nil)
    }
  end

  @impl true
  def handle_event("mark_attendance", %{"type" => "manual"=type}, socket) do
    course_offer = socket.assigns.course_offer

    attendance_data = get_attendance_data(course_offer)

#    student_dropdown = Enum.map(course_offer.student_courses, fn s_course ->
#      student = s_course.student
#      %{
#        id: student.id,
#        student_name: Enum.join([student.first_name, student.last_name], " "),
#        roll_no: student.roll_no,
#        attendance: false,
#        attend_dropdown: [{"Absent", s_course.id}, {"Present", s_course.id}],
#        student_course_id: s_course.id,
#        force_update: "#{student.id }" <> (DateTime.utc_now |> DateTime.to_unix |> to_string) #Temp Fix, Not re rendered(class not updated). Will investigate late.
#      }
#    end)

    date_data = get_date_data(course_offer)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
#    if connected?(socket), do: Process.send_after(self(), "setup_dates", 1)

    {
      :noreply,
      socket
      |> assign(attendance_type: type)
      |> assign(c_students: attendance_data)
      |> assign(date_data: date_data)
      |> assign(attend_file: nil)
    }
  end

  @impl true
  def handle_event("attendance_date", %{"_target" => ["date"], "date" => date}, socket) do
    date_data = socket.assigns.date_data
                |> Map.put(:selected_date, date)

    attendances = socket.assigns.c_students
                  |> Enum.map(&(&1.student_course_id))
                  |> Attendances.get_by_s_course(%{"date" => date})

    # Default Attendance
    c_students = if length(attendances) == 0 do
      Enum.map(
        socket.assigns.c_students,
        fn std ->
          Attendances.create_attendance(
            %{
              student_course_id: std[:student_course_id],
              status: false,
              date: date
            }
          )
          force_update = "#{std.id }" <> (DateTime.utc_now |> DateTime.to_unix |> to_string) #Temp Fix, Not re rendered(class not updated). Will investigate late.
          std
          |> Map.put(:force_update, force_update)
          |> Map.put(:attendance, false)

        end
      )
    else
    
      socket.assigns.course_offer.id
      |> StudentCourses.get_student_course_preloads(%{"date" => date})
      |> Enum.map(
           fn s_c ->
             student = s_c.student
             atd = List.first(s_c.attendances)
             %{
               id: student.id,
               student_name: Enum.join([student.first_name, student.last_name], " "),
               roll_no: student.roll_no,
               attendance: atd.status,
               attend_dropdown: [{"Absent", "#{s_c.id}_a"}, {"Present", "#{s_c.id}_p"}],
               student_course_id: s_c.id,
               force_update: "#{student.id }" <> (DateTime.utc_now |> DateTime.to_unix |> to_string) #Temp Fix, Not re rendered(class not updated). Will investigate late.
             }
           end
         )
    end

    attend_file = App.Context.AttendFiles.get_one(socket.assigns.course_offer.id, date)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {:noreply,
      socket
      |> assign(date_data: date_data)
      |> assign(c_students: c_students)
      |> assign(attend_file: attend_file)
    }
  end
  
  @impl true
  def handle_event("update_attendance", %{"_target" => [("s_course_" <> id) = p]}=params, socket) do
    [id, status] = params
                   |> Map.get(p)
                   |> String.split("_")
    status = (status == "p")
    date = socket.assigns.date_data[:selected_date]

    attendance = Attendances.get_by_s_course(id, %{"date" => date}) |> List.first

    c_students = case Attendances.update_attendance(attendance, %{status: status}) do
      {:ok, attendance} ->
        Enum.map(
          socket.assigns.c_students,
          fn std ->
            if (std.student_course_id == attendance.student_course_id) do
              force_update = DateTime.utc_now
                             |> DateTime.to_unix
                             |> to_string #Temp Fix, Not re rendered(class not updated). Will investigate late.
              std
              |> Map.put(:attendance, attendance.status)
              |> Map.put(:force_update, "#{std.id }" <> force_update)
            else
              std
            end
          end
        )

      {:error, _} -> socket.assigns.c_students
    end

    IO.inspect("=============c_students=============")
    IO.inspect(c_students)
    IO.inspect("=============c_students=============")

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {:noreply,
      socket
      |> assign(c_students: c_students)
    }
  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    {
      :noreply,
      socket
      |> assign(:modal, modal)
      |> assign(:attend_file, nil)
      |> assign(:c_students, nil)
      |> assign(:attendance_type, nil)
      |> assign(:date_data, nil)
    }
  end

  @impl true
  def handle_event(event, params, socket) do
    IO.inspect("=============start event=============")
    IO.inspect(event)
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============end event=============")

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

  @impl true
  def handle_info("setup_dates", socket) do
    {
      :noreply,
      push_event(
        socket,
        "setup_dates",
        %{"data" => socket.assigns.date_data}
      )
    }
  end

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
    params =  month && %{"month" => month}

    start_date = get_date(c_offer.start_date)
    end_date = get_date(c_offer.end_date)

    attendances = Attendances.get_by_s_course(s_course_ids, params)

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

  def get_date_data(%App.Schema.CourseOffer{} = course_offer) do
    course_offer = course_offer

    {:ok, today} = "Etc/UTC" |> DateTime.now()
    today = today |> DateTime.to_date()

    date_compare = today |> Date.compare(course_offer.end_date)
    max_date = (date_compare == :lt) && today || course_offer.end_date #Shouldn't allow future dates

    %{
      excluded_dates: Date.range(course_offer.start_date, max_date) |> Enum.flat_map(&((Date.day_of_week(&1) in [6, 7]) && [Date.to_string(&1)] || [])),
      min_date: course_offer.start_date,
      max_date: max_date,
      selected_date: nil
    }
  end

  def mark_auto_attendance(user_ids, date, socket) do
    s_courses = user_ids
                |> StudentCourses.get_by_user_ids(socket.assigns.course_offer.id)

    filtered_s_courses = user_ids
                       |> StudentCourses.filter_by_user_ids(socket.assigns.course_offer.id)

    attendances = s_courses
                  |> Enum.map(&(&1.id))
                  |> Attendances.get_by_s_course(%{"date" => date})

    if(length(attendances) == 0) do
      Enum.map(
        s_courses,
        fn s_c ->
          attr = %{
            student_course_id: s_c.id,
            status: true,
            date: date
          }
          Attendances.create_attendance(attr)
        end
      )
      Enum.map(
        filtered_s_courses,
        fn s_c ->
          attr = %{
            student_course_id: s_c.id,
            status: false,
            date: date
          }
          Attendances.create_attendance(attr)
        end
      )
      else
      Enum.map(
        s_courses,
        fn s_c ->
          attr = %{
            student_course_id: s_c.id,
            status: true,
            date: date
          }

          attendances
          |> Enum.find(&(&1.student_course_id == s_c.id))
          |> Attendances.update_attendance(attr)
        end
      )
    end
  end

  def get_attendance_data(%App.Schema.CourseOffer{}=course_offer) do
    Enum.map(course_offer.student_courses, fn s_course ->
      student = s_course.student
      %{
        id: student.id,
        user_id: student.user_id,
        student_name: Enum.join([student.first_name, student.last_name], " "),
        roll_no: student.roll_no,
        attendance: false,
        attend_dropdown: [{"Absent", s_course.id}, {"Present", s_course.id}],
        student_course_id: s_course.id,
        force_update: "#{student.id }" <> (DateTime.utc_now |> DateTime.to_unix |> to_string) #Temp Fix, Not re rendered(class not updated). Will investigate late.
      }
    end)
  end
end