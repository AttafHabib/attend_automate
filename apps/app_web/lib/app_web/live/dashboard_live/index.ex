defmodule AppWeb.DashboardLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  def mount(params, session, socket) do
    {
      :ok,
      socket
    }
  end


end