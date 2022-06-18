defmodule App.Guardian.ErrorHandler do

  import Phoenix.LiveView.Controller
  import Phoenix.Controller

  def auth_error(conn, {type, _reason}, _opts) do
    return(conn, String.downcase(to_string(type)))
  end

  def auth_error(conn, error) do
    return(conn, String.downcase(to_string(error)))
  end

  defp return(conn, "unauthenticated") do
    conn
    |> App.Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp return(conn, "unauthorized") do
    conn
    |> redirect(to: "/login")
  end

  defp return(conn, _error) do
    conn
    |> App.Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

end
