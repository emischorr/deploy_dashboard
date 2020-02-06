defmodule DeployDashboardWeb.BannerLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias DeployDashboardWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""

    <%= if (@blocker.count > 0) do %>
      <div class="warning-banner"><%= @blocker.count %> <a target="_blank" href="<%= @blocker.link %>">Update-Blocker</a></div>
    <% end %>

    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok, check_blocker(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, check_blocker(socket)}
  end


  defp check_blocker(socket) do
    assign( socket, blocker: DeployDashboard.info[:blocker] )
  end

end
