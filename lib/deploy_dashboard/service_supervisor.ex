defmodule DeployDashboard.ServiceSupervisor do
  use DynamicSupervisor

  def start_link(opts) do
    {:ok, _pid} = DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_child(name) do
    spec = {DeployDashboard.Service, name: name}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end


  # Callbacks

  @impl true
  def init(init_arg) do
    IO.puts "Started ServiceSupervisor"
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [init_arg])
  end

end
