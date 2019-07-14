defmodule DeployDashboard do
  @moduledoc """
  DeployDashboard keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require Logger

  alias DeployDashboard.Git
  alias DeployDashboard.RepoWatcher

  def services do
    case File.ls("services") do
      {:ok, services} -> services
        |> Enum.filter(&( File.dir?("services/"<>&1) ))
        |> Enum.map(&( %{
            name: &1,
            branches: Git.unmerged_feature_branches(&1),
            commits: Git.commits_not_deployed(&1)
          } ))
      {:error, :enoent} ->
        Logger.error("Directory 'services' not found!")
        []
    end
  end

  def add_service(url, name) do
    RepoWatcher.add(url, name)
  end
end
