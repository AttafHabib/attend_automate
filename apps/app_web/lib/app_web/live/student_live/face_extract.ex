defmodule AppWeb.StudentLive.FaceExtract do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files}
  alias App.Schema.{Student, File}
  alias AppWeb.Utils.ClientHelper

  def mount(%{"id" => id, "action" => "extract"}, session, socket) do
    student = Students.get_student!(id)
              |> Context.preload_selective([:user, :face_images])

    {
      :ok,
      socket
      |> assign(student: student)
    }
  end


  def handle_event("get_face", params, socket) do
    user_id = socket.assigns.student.user.id
    socket = case ClientHelper.get_user_face(user_id) do
      {:ok, params} -> params |> Map.put("user_id", user_id) |> add_files

                       socket
                       |> put_flash(:info, "Face Successfully Added")

      {:error, data} -> params |> Map.put("user_id", user_id) |> add_files

                        socket
                        |> put_flash(:error, "Unrecognizable face! Please correct camera or lightning")
    end

    student = Students.get_student!(socket.assigns.student.id)
              |> Context.preload_selective([:user, :face_images])

    {
      :noreply,
      socket
      |> assign(student: student)
    }
  end


  def add_files(%{"f_image" => f_image, "full_image" => full_image, "user_id" => user_id}) do
    f_image &&
      Context.create(File, %{path: "uploads/#{f_image}", tag: "face_image", user_id: user_id})

    # Full image is already replaced by latest by python module, so no need to update reference
    Files.get_by_tag!("full_image", user_id)|>IO.inspect
    ||
      Context.create(File, %{path: "uploads/#{full_image}", tag: "full_image", user_id: user_id})
  end

  def add_files(params) do
    nil
  end
end