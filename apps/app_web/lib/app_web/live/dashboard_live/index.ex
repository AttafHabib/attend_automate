defmodule AppWeb.DashboardLive.Index do
  use AppWeb, :live_view

  def mount(params, session, socket) do
    {
      :ok,
      socket
    }
  end

end