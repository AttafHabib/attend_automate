defmodule AppWeb.UserLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Context
  alias App.Context.{Users, Students, Roles, Teachers}
  alias App.Schema.{User, Role, Student, Teacher, UserRole}

  # alias App.Helpers

  @impl true
  def mount(_params, _session, socket) do
    users = Users.list_users()

    {:ok,
      socket
      |> assign(users: users)
      |> assign(all_users: users)
    }
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    users = Enum.filter(
      socket.assigns.all_users,
      fn user ->
        user.username
        |> String.downcase()
        |> String.contains?(value)
      end
    )

    {
      :noreply,
      socket
      |> assign(search_value: value)
      |> assign(users: users)
    }
  end

  @impl true
  def handle_event("search_bar", _, socket) do
    socket = if(socket.assigns[:search_bar]) do
      socket
      |> assign(users: socket.assigns.all_users)
      |> assign(search_value: "")
    else
      socket
    end

    {
      :noreply,
      socket
      |> assign(search_bar: !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("validate_email", %{"value" => email}, socket) do
    changes = socket.assigns.changeset_user.changes |> Map.put(:email, email)
    changeset_user = Context.change(User, %User{}, changes) |> Map.put(:action, :validate)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)


    {:noreply,
      socket
      |> assign(changeset_user: changeset_user)
    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["user", "role", role], "user" => %{"role" => params}} = p, socket) do
    role = (params[role] == "true") && role

    dropdown_profile = case role do
      "admin" -> []
      "teacher" -> Teachers.list_teachers(false) |> Enum.map(&({&1.first_name <> " " <> &1.last_name, &1.id}))
      "student" -> Students.list_students(false) |> Enum.map(&({&1.first_name <> " " <> &1.last_name, &1.id}))
    end

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {:noreply,
      socket
      |> assign(role: role)
      |> assign(dropdown_profile: dropdown_profile)
      |> assign(changeset_user: Context.change(User, %User{}))
      |> assign(u_password: nil)
      |> assign(selected_prof: nil)
      |> assign(show_password: nil)

    }
  end

  @impl true
  def handle_event("validate", %{"_target" => ["user", "type", role_type], "user" => %{"type" => params}} = p, socket) do
    {data, s_profile} = case role_type do
      "student" -> {Context.get(Student, params[role_type]), params["student"]}
      "teacher" -> {Context.get(Teacher, params[role_type]), params["teacher"]}
    end

    user = Users.get_user(data.email)
    email = if(user) do
      nil
    else
      data.email
    end

    params = %{
      username: Enum.join(["#{data.first_name}", "#{data.last_name}", " "]),
      email: email,
      password: App.PasswordGenerator.generate(),
    }

    changeset_user = Context.change(User, %User{}, params)

    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)

    {:noreply,
      socket
      |> assign(changeset_user: changeset_user)
      |> assign(u_password: params[:password])
      |> assign(selected_prof: s_profile)
    }
  end

  def handle_event("show_password", p, socket) do
    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
    {:noreply, assign(socket, :show_password, !socket.assigns[:show_password])}
  end

#  role = Roles.get_by_role(role_type)

  #  @impl true
#  def handle_event("validate", %{"_target" => ["user", "role", role_id], "user" => params} = params_, socket) do
#    IO.inspect("=============_params=============")
#    IO.inspect(params_)
#    IO.inspect("=============_params=============")
#    if connected?(socket), do: Process.send_after(self(), "display_modals", 1)
#
#    profiles = case role_id do
#      "2" -> Students.list_students(false) |> Enum.map(&({&1.first_name <> " " <> &1.last_name, &1.id}))
#      "3" -> []
#    end
#
#    params = update_in(params["role"], fn x -> role_id end)
#
#    {
#      :noreply,
#      socket
#      |> assign(:user_params, params)
#      |> assign(:profiles, profiles)
#    }
#  end

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
  def handle_event("save", %{"user" => %{"type" => %{"teacher" => id}} = params}, socket) do
    case Context.create(User, params) do
      {:ok, user} -> role = Roles.get_by_role(socket.assigns.role)
                     Context.create(UserRole, %{user_id: user.id, role_id: role.id})

                     teacher = Context.get(Teacher, id)
                     IO.inspect("=============teacher=============")
                     IO.inspect(teacher)
                     IO.inspect(%{user_id: user.id})
                     IO.inspect("=============teacher=============")
                     Context.update(Teacher, teacher, %{user_id: user.id})

                     users = Users.list_users()

                     if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

                     {:noreply, assign(socket, users: users)}
      {:error, changeset} -> IO.inspect("=============changeset=============")
                             IO.inspect(changeset)
                             IO.inspect("=============changeset=============")

                             {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Context.create(User, params) do
      {:ok, user} -> role = Roles.get_by_role(socket.assigns.role)
                     Context.create(UserRole, %{user_id: user.id, role_id: role.id})

                     student = Context.get(Student, params["type"]["student"])
                     Context.update(Student, student, %{user_id: user.id})

                     users = Users.list_users()

                     if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

                     {:noreply, assign(socket, :users, users)}
      {:error, changeset} -> {:noreply, socket}
    end
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
#    roles = Context.list(Role, 0)

    {
      :noreply,
      socket
      |> assign(modal: modal)
      |> assign(changeset_user: changeset_user)
#      |> assign(roles: roles)
      |> assign(u_password: nil)
      |> assign(selected_prof: nil)
      |> assign(show_password: nil)
      |> assign(role: "admin")
#      |> assign(profiles: [])
    }
  end

  @impl true
  def handle_event(event, params, socket) do
    IO.inspect("=============event=============")
    IO.inspect(event)
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")
    {:noreply, socket}
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
