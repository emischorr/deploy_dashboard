defmodule DeployDashboardWeb.PageController do
  use DeployDashboardWeb, :controller

  def index(conn, _params) do
    services = DeployDashboard.services
    render(conn, "index.html", services: services)
  end
end
