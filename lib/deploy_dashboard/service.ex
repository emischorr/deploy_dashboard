defmodule DeployDashboard.Service do
  use GenServer

  alias DeployDashboard.Git

  @update_time 5000

  # client calls
  def start_link(_children, [name: name]) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{name: name}, name: :"Service-#{name}")
  end


  # Callbacks

  @impl true
  def init(state) do
    IO.puts "Started watching #{state.name}"
    Process.send_after(self(), :update, @update_time)
    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do

    Git.update_repo(state.name)

    Process.send_after(self(), :update, @update_time)
    {:noreply, state}
  end
end
