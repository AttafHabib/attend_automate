defmodule AppWeb.SidebarLive.SideBar do
  use AppWeb, :live_view

  alias App.Context.Users

  def mount(params, session, socket) do
    case Users.verify_user(session["guardian_default_token"]) do
      {:ok, user} ->

        {:ok,
          socket
          |> assign(user: user)
        }

      {:error, reason} ->
        {:ok, push_redirect(socket, to: "/login")}
    end
  end

end