defmodule App.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      App.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: App.PubSub}
      # Start a worker by calling: App.Worker.start_link(arg)
      # {App.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: App.Supervisor)
  end
end
