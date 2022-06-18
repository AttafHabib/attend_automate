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

  def handle_event(event, _params, socket) do
    IO.inspect("=============event=============")
    IO.inspect(event)
    IO.inspect(_params)
    IO.inspect("=============event=============")

    {:noreply, socket}
  end
end