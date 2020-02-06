defmodule DeployDashboard.Dashboard do
  use GenServer

  alias DeployDashboard.Jira

  @update_time 60000 # 1 minute

  @init_state %{blocker: %{count: 0, link: ""}}

  # client calls
  def start_link(_children) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, %{}, name: Dashboard)
  end

  def info(), do: GenServer.call(Dashboard, :info)


  # Callbacks

  @impl true
  def init(_state) do
    IO.puts "Started Dashboard"
    Process.send_after(self(), :update, @update_time)
    {:ok, @init_state}
  end

  @impl true
  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:update, state) do
    Process.send_after(self(), :update, @update_time)
    {:noreply, update(state)}
  end

  defp update(state) do
    blocker_link = case get_config() do
      %{"jira_base_url" => base_url, "jira_blocker_query" => jql} -> "#{base_url}/issues?jql=#{jql}"
      _ -> ""
    end

    Map.put(state, :blocker, %{count: Jira.blocker, link: blocker_link})
  end

  defp get_config() do
    path = Path.join(File.cwd!(), ".jira.yml")
    case YamlElixir.read_from_file(path) do
      {:ok, config} -> config
      {:error, %YamlElixir.FileNotFoundError{message: _msg}} -> %{}
    end
  end
end
