defmodule AppWeb.StudentLive.FaceExtract do
  use AppWeb, :live_view
  alias App.Context
  alias App.Context.{Students, CourseOffers}
  alias App.Schema.{Student}
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
    case ClientHelper.get_user_face(user_id) do
      {:ok, data} -> img_ = Base.encode64(data)
                     {
                       :noreply,
                       socket
                       |> assign(face_image: img_)
                     }
      {:error, data} -> img_ = Base.encode64(data)
                        {
                          :noreply,
                          socket
                          |> assign(face_image: img_)
                          |> put_flash(:error, "Image not recognized")
                        }
    end
  end
end