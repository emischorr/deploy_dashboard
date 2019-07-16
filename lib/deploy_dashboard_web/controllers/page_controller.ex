defmodule DeployDashboardWeb.PageController do
  use DeployDashboardWeb, :controller

  def index(conn, _params) do
    services = DeployDashboard.services
    render(conn, "index.html", services: services, selected_service: nil)
  end

  def show(conn, %{"service" => name}) do
    services = DeployDashboard.services
    selected_service = DeployDashboard.service(name)
    render(conn, "index.html", services: services, selected_service: selected_service)
  end
end
