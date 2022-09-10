defmodule AppWeb.StudentLive.FaceExtractComponent do
  use AppWeb, :live_component
  alias App.Context
  alias App.Context.{Students, CourseOffers, Files}
  alias App.Schema.{Student, File}
  alias AppWeb.Utils.ClientHelper

  def update(%{student_id: id}, socket) do
    student = Students.get_student!(id) |> IO.inspect()
                  |> Context.preload_selective([:user, :face_images])

    {
      :ok,
      socket
      |> assign(student: student)
      |> assign(img_id: DateTime.utc_now |> DateTime.to_unix |> to_string)
    }
  end

  @impl true
  def handle_event("get_face", params, socket) do
    student = socket.assigns.student
    user_id = student.user.id
    case ClientHelper.get_user_face(user_id, String.downcase(student.first_name)) do
      {:ok, params} -> IO.inspect(params, label: :params)

        params |> Map.put("user_id", user_id) |> add_files
                       student = Students.get_student!(student.id)

                       if connected?(socket), do: Process.send_after(self(), "open_modals_show_full_image", 300)
                       if connected?(socket), do: Process.send_after(self(), "close_modals_show_full_image", 10000)

                       {
                         :noreply,
                         socket
                         |> assign(student: student)
                         |> assign(img_id: DateTime.utc_now |> DateTime.to_unix |> to_string)
                         |> assign(modal: "show_full_image")
                       }

      {:error, data} -> params |> Map.put("user_id", user_id) |> add_files
                        if connected?(socket), do: Process.send_after(self(), "open_modals_show_full_image", 300)
                        if connected?(socket), do: Process.send_after(self(), "close_modals_show_full_image", 10000)

                        {
                          :noreply,
                          socket
                          |> put_flash(:error, "Unrecognizable face! Please correct camera or lightning")
                          |> assign(img_id: DateTime.utc_now |> DateTime.to_unix |> to_string)
                          |> assign(modal: "show_full_image")
                        }
    end
  end

  def add_files(%{"f_image" => f_image, "full_image" => full_image, "user_id" => user_id}) do
    f_image &&
      Context.create(File, %{path: "uploads/#{user_id}/#{f_image}", tag: "face_image", user_id: user_id})

    # Full image is already replaced by latest by python module, so no need to update reference
    Files.get_by_tag!("full_image", user_id)
    ||
      Context.create(File, %{path: "uploads/#{full_image}", tag: "full_image", user_id: user_id})
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