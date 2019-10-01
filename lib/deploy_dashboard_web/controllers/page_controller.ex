defmodule DeployDashboardWeb.PageController do
  use DeployDashboardWeb, :controller

  def dashboard(conn, _params) do
    services = DeployDashboard.services
    render(conn, "dashboard.html", services: services)
  end

  def index(conn, _params) do
    services = DeployDashboard.services
    render(conn, "index.html", services: services, selected_service_name: nil)
  end

  def show(conn, %{"service" => name}) do
    services = DeployDashboard.services
    render(conn, "index.html", services: services, selected_service_name: name)
  end
end
