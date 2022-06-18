defmodule AppWeb.SessionController do
  use AppWeb, :controller

  alias App.Context.Users
  alias App.Guardian

  def login(conn, %{"user" => %{"email" => email, "password" => password} = params}) do
    case Users.authenticate_user(email, password) do
      {:error, reason} ->
        live_render(conn, AppWeb.SessionLive.Login, session: %{"error" => reason, "user" => params})
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/dashboard")
    end
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

end