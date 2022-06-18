defmodule AppWeb.SessionController do
  use AppWeb, :controller

  def login(_conn, _params) do
    redirect(_conn, to: "/login")
  end
end