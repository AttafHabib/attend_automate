defmodule AppWeb.TopbarLive.TopBar do
  use AppWeb, :live_view


  def mount(params, session, socket) do


    {:ok, socket, layout: false}
  end
end