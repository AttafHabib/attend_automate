defmodule AppWeb.AttendanceLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Helpers
  alias App.Context

  def mount(params, session, socket) do
    user = Helpers.get_current_user(session["guardian_default_token"])

    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:action, nil)
    }
  end

  @impl true
  def handle_event("get_face", _, socket) do
    port = Port.open(
      {:spawn, "python3 main.py"},
      [:binary, :nouse_stdio, {:packet, 4}]
    )

    {
      :noreply,
      socket
      |> assign(action: :get_face)
    }
  end

#  @impl true
#  def handle_event("open_modals", %{"modal" => modal}, socket) do
#    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)
#
#    {
#      :noreply,
#      socket
#      |> assign(:modal, modal)
#    }
#  end
end