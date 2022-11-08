defmodule AppWeb.DashboardLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  def mount(params, session, socket) do
    st_count = App.Context.count(App.Schema.Student)
    teacher_count = App.Context.count(App.Schema.Department)
    dpt_count = App.Context.count(App.Schema.Teacher)
    {
      :ok,
      socket
      |> assign(st_count: st_count)
      |> assign(teacher_count: teacher_count)
      |> assign(dpt_count: dpt_count)
    }
  end


end