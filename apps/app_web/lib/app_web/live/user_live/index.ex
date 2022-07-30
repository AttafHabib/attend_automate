defmodule AppWeb.UserLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Context
  alias App.Context.{Users, Students}
  alias App.Schema.{User, Role, Student}

  # alias App.Helpers

  @impl true
  def mount(_params, _session, socket) do
    users = Users.list_users()

    {:ok,
      socket
      |> assign(:users, users)
    }
  end

  @impl true
  def handle_event("search_bar", _, socket) do

    {
      :noreply,
      socket
      |> assign(:search_bar, !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["user", "role", role_id], "user" => params} = params_, socket) do
    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    profiles = case role_id do
      "2" -> Students.list_students(false) |> Enum.map(&({&1.first_name <> " " <> &1.last_name, &1.id}))
      "3" -> []
    end

    params = update_in(params["role"], fn x -> role_id end)

    {
      :noreply,
      socket
      |> assign(:user_params, params)
      |> assign(:profiles, profiles)
    }
  end

#  @impl true
#  def handle_event("validate", %{"user" => params} = _params, socket) do
#    IO.inspect("=============params=============")
#    IO.inspect(params)
#    IO.inspect("=============params=============")
#    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
#    params = update_in(params["role"], fn x -> socket.assigns[:user_params]["role"] end)
#
#    changeset_user = Context.change(User, %User{}, params) |> Map.put(:action, :validate)
#
#    IO.inspect params
#    IO.inspect("=============param2212s=============")
#
#    {
#      :noreply,
#      socket
#      |> assign(:user_params, params)
#      |> assign(:changeset_user, changeset_user)
#    }
#  end
  
  @impl true
  def handle_event("save", params, socket) do
#    Context.create(Student, params)
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")
    {
      :noreply,
      socket
      |> assign(:modal, nil)
    }
  end

  @impl true
  def handle_event("close_modals", _, socket) do
    if connected?(socket), do: Process.send_after(self(), "close_modals", 100)

    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    changeset_user = Context.change(User, %User{})
    roles = Context.list(Role, 0)

    {
      :noreply,
      socket
      |> assign(:modal, modal)
      |> assign(:changeset_user, changeset_user)
      |> assign(:roles, roles)
      |> assign(:profiles, [])
    }
  end

  @impl true
  def handle_info("close_modals", socket) do
    {
      :noreply,
      assign(socket, :modal, nil)
#      push_event(
#        assign(socket, :modal, nil),
#        "close_modals",
#        %{"modal" => socket.assigns.modal}
#      )
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


end
