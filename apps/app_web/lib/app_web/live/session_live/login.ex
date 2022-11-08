defmodule AppWeb.SessionLive.Login do
  use AppWeb, :live_view
  alias App.Context.Users
  alias App.Helpers
  alias App.Schema.User

  def mount(params, session, socket) do
    socket = cond do
      !session["error"] && session["guardian_default_token"] ->
        case Users.verify_user(session["guardian_default_token"]) do
          {:ok, _user} -> push_redirect(socket, to: "/dashboard")
          {:error, reason} -> redirect(socket, to: "/logout")
        end

      error = session["error"] -> user_changeset = Users.change_user(%User{}, session["user"] || %{})
                                  user_changeset = case error do
                                                     :invalid_email -> Helpers.add_error(user_changeset, {:email, "Invalid Email"})
                                                     :invalid_password -> Helpers.update_error(user_changeset, {:password, "Invalid Password"})
                                                   end
                                                   |> Map.put(:action, :validate)

                                  assign(socket, :changeset, user_changeset)
        true ->
          assign(socket, :changeset, Users.change_user())
    end

    {:ok, socket}

  end

  @impl true
  def handle_event("reset_password", %{"email" => email}, socket) do
    socket = case Users.get_user(email) do
      nil ->    socket |> assign(error_message: "Account doesn't exist. Please contact admin for registering a new account.")
      user ->    token = Phoenix.Token.sign(AppWeb.Endpoint, "user auth", user.id)
                 base_url = Application.get_env(:app, App.Mailer)[:email_base_url]

                 App.Mailer.Email.update_password_email(
                   user.email,
                   "Reset Password",
                   "Please click the below link to reset your Password
                 <a href='#{base_url}/users/#{token}/edit'> Update Password </a>",
                   "Reset Password"
                 )

                 socket
                 |> assign(show_message: "Email has been sent successfully. Please check your inbox and follow instructions to reset password.")
      _ -> socket
    end
    {
      :noreply,
      socket
    }
  end

  def handle_event("forget_password", _, socket) do
    {
      :noreply,
      socket
      |> assign(toggle_forget_pass: !socket.assigns[:toggle_forget_pass])
      |> assign(show_message: nil)
      |> assign(error_message: nil)
    }
  end

  def handle_event(event, _params, socket) do
    IO.inspect("=============event=============")
    IO.inspect(event)
    IO.inspect(_params)
    IO.inspect("=============event=============")

    {:noreply, socket}
  end
end