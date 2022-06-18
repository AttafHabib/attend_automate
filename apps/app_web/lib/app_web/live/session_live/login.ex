defmodule AppWeb.SessionLive.Login do
  use AppWeb, :live_view

  def mount(params, session, socket) do
    IO.inspect "############ IN MOUNT ############"
    IO.inspect("")
    IO.inspect "############ IN MOUNT ############"
    {
      :ok,
      socket
      |> assign(:changeset, %{})
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