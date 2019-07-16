defmodule DeployDashboard do
  @moduledoc """
  DeployDashboard keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require Logger

  alias DeployDashboard.RepoWatcher
  alias DeployDashboard.Service

  def services do
    case File.ls("services") do
      {:ok, services} -> services
        |> Enum.filter(&( File.dir?("services/"<>&1) ))
        |> Enum.map(&( Service.info(&1) ))
        |> Enum.sort(&( &1.name < &2.name ))
      {:error, :enoent} ->
        Logger.error("Directory 'services' not found!")
        []
    end
  end

  def service(name) do
    Service.info(name)
  end

  def add_service(url, name) do
    RepoWatcher.add(url, name)
  end
end
