defmodule DeployDashboard.Git do
  require Logger

  def create_repo(url, name) do
    folder_name = name |> String.replace(" ", "_") |> String.trim()
    File.mkdir("services")
    File.cd("services")
    System.cmd("git", ~w"clone --bare -- #{url} #{folder_name}")
    File.cd("..")
    folder_name
  end

  def update_repo(name) do
    System.cmd("git", ~w"--git-dir=services/#{name} fetch", stderr_to_stdout: true)
  end

  def unmerged_feature_branches(name) do
    case System.cmd("git", ~w"--git-dir=services/#{name} branch --no-merged master") do
      {branches, 0} -> branches
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.filter(&( String.contains?(String.downcase(&1), "next") ))
      {result, exit_code} ->
        []
    end
  end

  def commits_not_deployed(name, tag \\ "latest") do
    case System.cmd("git", ~w"--git-dir=services/#{name} log --oneline --no-merges master..#{tag}", stderr_to_stdout: true) do
      {commits, 0} -> commits
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.filter(&( String.length(&1) > 0 ))
      {error, 128} ->
        Logger.error("Error while trying to get commits from repo '#{name}': #{error}")
        []
    end
  end

end
