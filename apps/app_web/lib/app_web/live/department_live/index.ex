defmodule AppWeb.DepartmentLive.Index do
  use AppWeb, :live_view
  import AppWeb.Components.BreadCrumb

  alias App.Context
  alias App.Schema.Department

  def mount(params, session, socket) do
    departments = Context.list(Department)
                  |> Context.preload_selective([:students, :courses])

    {
      :ok,
      socket
      |> assign(:departments, departments)
    }
  end

  @impl true
  def handle_event("search_bar", _, socket) do
    {
      :noreply,
      socket
      |> assign(:search_bar, !socket.assigns[:search_bar])
    }
  end

  @impl true
  def handle_event("search", %{"value" => search_string} = params, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("save", %{"department" => params}, socket) do
    IO.inspect("=============params=============")
    IO.inspect(params)
    IO.inspect("=============params=============")

    case Context.create(Department, params) do
      {:ok, dpt} ->
        if connected?(socket), do: Process.send_after(self(), "close_modals", 300)

        departments = Context.list(Department)
        {
          :noreply,
          socket
          |> assign(:departments, departments)
        }
      {:error, changeset_} -> {:noreply, socket}

    end

  end

  @impl true
  def handle_event("open_modals", %{"modal" => modal}, socket) do
    if connected?(socket), do: Process.send_after(self(), "open_modals", 300)

    changeset_dpt = Context.change(Department, %Department{})

    {
      :noreply,
      socket
      |> assign(:modal, modal)
      |> assign(:changeset_dpt, changeset_dpt)
    }
  end

  @impl true
  def handle_event("close_modals", _, socket) do
    if connected?(socket), do: Process.send_after(self(), "close_modals", 100)

    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info("open_modals", socket) do
    {
      :noreply,
      push_event(
        socket,
        "open_modals",
        %{"modal" => socket.assigns.modal}
      )
    }
  end

  @impl true
  def handle_info("close_modals", socket) do
    {
      :noreply,
      push_event(
        socket,
        "close_modals",
        %{"modal" => socket.assigns.modal}
      )
    }
  end
end