defmodule DeployDashboardWeb.DetailLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias DeployDashboardWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""

      <div class="content">
        <h2><%= @service.name %></h2>
        <div class="version"><%= semver(@service.version) %></div>
        <hr />
        <h3>Features in work</h3>
        <ul class="branch-list">
          <%= for branch <- @service.branches do %>
            <li><%= branch %></li>
          <% end %>
        </ul>
        <%= if length(@service.commits) > 0 do %>
          <h3>Commits not deployed</h3>
          <ul class="branch-list">
            <%= for commit <- @service.commits do %>
              <li><%= commit %></li>
            <% end %>
          </ul>
        <% end %>
      </div>

    """
  end

  def mount(%{service_name: name}, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, put_service(socket, name)}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_service(socket)}
  end


  defp put_service(socket, name) do
    assign(socket, service: DeployDashboard.service(name))
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
