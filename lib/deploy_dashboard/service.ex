defmodule DeployDashboard.Service do
  use GenServer

  alias DeployDashboard.Git

  @update_time 5000

  # client calls
  def start_link(_children, [name: name]) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{name: name}, name: :"Service-#{name}")
  end

  def info(name) do
    GenServer.call(:"Service-#{name}", :info)
  end


  # Callbacks

  @impl true
  def init(state) do
    IO.puts "Started watching #{state.name}"
    Process.send_after(self(), :update, @update_time)
    {:ok, Map.merge(state, %{branches: [], commits: [], version: ""})}
  end

  @impl
  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:update, state) do
    Process.send_after(self(), :update, @update_time)
    {:noreply, update(state)}
  end

  defp update(state) do
    Git.update_repo(state.name)
    state
    |> Map.put(:branches, Git.unmerged_feature_branches(state.name))
    |> Map.put(:commits, Git.commits_not_deployed(state.name))
  end
end
