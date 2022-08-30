defmodule AppWeb.StudentLive.FaceExtract do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files}
  alias App.Schema.{Student, File}
  alias AppWeb.Utils.ClientHelper

  def mount(%{"id" => id, "action" => "extract"}, session, socket) do
    student = Students.get_student!(id) |> IO.inspect()
#              |> Context.preload_selective([:user, :face_images])

    {
      :ok,
      socket
      |> assign(student: student)
    }
  end

  @impl true
  def handle_event("get_face", params, socket) do
    user_id = socket.assigns.student.user.id
    socket = case ClientHelper.get_user_face(user_id) do
      {:ok, params} -> params |> Map.put("user_id", user_id) |> add_files
                       student = Students.get_student!(socket.assigns.student.id)

                       socket
                       |> assign(student: student)

      {:error, data} -> params |> Map.put("user_id", user_id) |> add_files

                        socket
                        |> put_flash(:error, "Unrecognizable face! Please correct camera or lightning")
    end

    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)
    if connected?(socket), do: Process.send_after(self(), "close_modals", 3000)

#    student = Students.get_student!(socket.assigns.student.id)
#              |> Context.preload_selective([:user, :face_images])

    {
      :noreply,
      socket
      |> assign(modal: "show_full_image")
      #      |> assign(student: student)
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
      )
    }
  end


  def add_files(%{"f_image" => f_image, "full_image" => full_image, "user_id" => user_id}) do
    f_image &&
      Context.create(File, %{path: "uploads/#{user_id}/#{f_image}", tag: "face_image", user_id: user_id})

    # Full image is already replaced by latest by python module, so no need to update reference
    Files.get_by_tag!("full_image", user_id)|>IO.inspect
    ||
      Context.create(File, %{path: "uploads/#{user_id}/#{full_image}", tag: "full_image", user_id: user_id})
  end

  def add_files(params) do
    nil
  end

  def get_total_faces(%Student{} = std) do
  Enum.count std.user.files, &(&1.tag == "face_image")
  end

  def get_full_face(%Student{} = std) do
    Enum.find std.user.files, &(&1.tag == "full_image")
  end
end