defmodule AppWeb.UserController do
  use AppWeb, :controller

  alias App.Context.Users
  alias App.Guardian

  def edit(conn, %{"token" => token}) do
    case Phoenix.Token.verify(AppWeb.Endpoint, "user auth", token, max_age: 86400) do
      {:ok, id} ->
        user = Users.get_user!(id)
        changeset = Users.change_user(user)
        render(conn, "edit.html", user: user, changeset: changeset, token: token)
      {:error, reasons} ->
        json(conn, %{"error" => "Unauthorized"})
    end
  end

  @spec update(%Plug.Conn{}, map()) :: any
  def update(conn, %{"id" => id, "user" => user_params, "token" => token}) do
    case Phoenix.Token.verify(AppWeb.Endpoint, "user auth", token, max_age: 86400) do
      {:ok, id} ->
        user = Users.get_user!(id)

        if user_params["password"] == user_params["confirm_password"] do
          case Users.update_user(user, %{password: user_params["password"]}) do
            {:ok, user} ->
              IO.inspect("=============user=============")
              IO.inspect(user)
              IO.inspect("=============user=============")
              conn
              |> redirect(to: "/login", replace: true)
            {:error, _reason} ->
              json(conn, %{"error" => "Update Password Failed"})
          end
        else
          changeset = Users.change_user(user)
          render(conn, "edit.html", user: user, changeset: changeset, token: token, error_msg: "Password doesn't match")

        end
      {:error, reasons} ->
        json(conn, %{"error" => "Unauthorized"})
    end
  end
end