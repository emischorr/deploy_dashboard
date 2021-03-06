defmodule DeployDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      DeployDashboardWeb.Endpoint,
      # Starts a worker by calling: DeployDashboard.Worker.start_link(arg)
      # {DeployDashboard.Worker, arg},
      DeployDashboard.ServiceSupervisor,
      DeployDashboard.RepoWatcher,
      DeployDashboard.Dashboard
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DeployDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DeployDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
