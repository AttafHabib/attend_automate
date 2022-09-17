defmodule AppWeb.StudentLive.Show do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb
  alias App.Context
  alias App.Context.{Students, Users}
  alias App.Schema.{Student}

  def mount(%{"id" => id}, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->     student = Students.get_student!(id) |> Context.preload_selective([:department, s_courses: [course_offer: :course]])
                         {
                           :ok,
                           socket
                           |> assign(student: student)
                           |> assign(user: user)
                           |> assign(tab_action: "attendance")
                         }
      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
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
  def handle_event("train_model", _, socket) do
    case AppWeb.Utils.ClientHelper.train_model() do
      {:ok, body} -> {:noreply, socket |> put_flash(:info, "Model Trained Succsessfully")}
      {:error, _} -> {:noreply, socket}
    end
  end

  @impl true
  def handle_event("show_course", %{"id" => id}, socket) do
    {:noreply,
      socket
      |> push_redirect(to: Routes.course_show_path(socket, :show, id))
    }
  end

  @impl true
  def handle_info("open_modals_" <> modal, socket) do
    {
      :noreply,
      socket
      |> assign(:modal, "show_full_image")
      |> push_event(
        "open_modals",
        %{"modal" => modal}
      )
    }
  end

  @impl true
  def handle_info("close_modals_" <> modal, socket) do
    {
      :noreply,
    socket
    |> assign(:modal,false)
    |> push_event(
        "close_modals",
        %{"modal" => modal}
      )
    }
  end
end