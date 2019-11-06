defmodule DeployDashboardWeb.ServiceLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias DeployDashboardWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <div class="service <%= if length(@service.commits) > 0, do: 'warn' %> <%= if length(@service.prs) > 0, do: 'pr' %>">
      <a href="<%= Routes.page_path(@socket, :show, @service.name) %>">
        <div class="info">
          <span class="name"><%= @service.name %></span>
          <span class="version"><%= semver(@service.version) %></span>
          <div class="branches"><%= length(@service.branches) %></div>
        </div>
      </a>
    </div>
    """
  end

  def mount(%{service_name: name, selected_service_name: selected_service_name}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)
    selected = name == selected_service_name

    {:ok, put_service(socket, name, selected)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_service(socket)}
  end


  defp put_service(socket, name, selected) do
    assign(socket, service: DeployDashboard.service(name), selected: selected)
  end
  defp put_service(socket) do
    assign( socket, service: DeployDashboard.service(socket.assigns.service.name) )
  end

  defp semver(%{major: major, minor: minor, patch: patch}) do
    "#{major}.#{minor}.#{patch}"
  end
  defp semver(%{}), do: "0.0.0"
  defp semver([]), do: "0.0.0"

end
