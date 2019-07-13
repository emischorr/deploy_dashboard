defmodule DeployDashboard.RepoWatcher do
  use GenServer

  require Logger
  alias DeployDashboard.ServiceSupervisor
  alias DeployDashboard.Git

  @update_time 5000

  # client calls
  def start_link(args) do
    {:ok, pid} = GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def add(url, name) do
    Git.create_repo(url, name)
    |> ServiceSupervisor.start_child()
  end


  # Callbacks

  @impl true
  def init(state) do
    IO.puts "Started RepoWatcher"
    Process.send_after(self(), :update, @update_time)
    {:ok, state}
  end

  @impl true
  def handle_info(:update, state) do
    init_services()
    #Process.send_after(self(), :update, @update_time)
    {:noreply, state}
  end


  defp init_services do
    case File.ls("services") do
      {:ok, services} -> services
        |> Enum.filter(&( File.dir?("services/"<>&1) ))
        |> Enum.map(&( ServiceSupervisor.start_child(&1) ))
      {:error, :enoent} -> Logger.error("Directory 'services' not found!")
    end
  end
end
