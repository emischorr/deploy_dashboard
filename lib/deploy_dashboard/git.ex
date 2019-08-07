defmodule DeployDashboard.Git do
  require Logger

  def create_repo(url, name) do
    folder_name = name |> String.replace(" ", "_") |> String.trim()
    File.mkdir("services")
    File.cd("services")
    System.cmd("git", ~w"clone -- #{url} #{folder_name}")
    File.cd("..")
    folder_name
  end

  def update_repo(name) do
    System.cmd("git", ~w"--git-dir=services/#{name}/.git fetch -p --tags --force", stderr_to_stdout: true)
  end

  def unmerged_feature_branches(name) do
    case System.cmd("git", ~w"--git-dir=services/#{name}/.git branch -r --no-merged origin/master") do
      {branches, 0} -> branches
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.map(&( String.trim(&1, "origin/") ))
        |> Enum.filter(&( String.contains?(String.downcase(&1), "next") ))
      {result, exit_code} ->
        []
    end
  end

  def commits_not_deployed(name, tag \\ "latest") do
    case System.cmd("git", ~w"--git-dir=services/#{name}/.git log --oneline --no-merges origin/master...#{tag}", stderr_to_stdout: true) do
      {commits, 0} -> commits
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.filter(&( String.length(&1) > 0 ))
      {error, 128} ->
        Logger.error("Error while trying to get commits from repo '#{name}': #{error}")
        []
    end
  end

  def tags(name, filter \\ "prod-*.*.[0-9]*") do
    case System.cmd("git", ~w"--git-dir=services/#{name}/.git tag -l #{filter}", stderr_to_stdout: true) do
      {tags, 0} -> tags
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.filter(&( String.length(&1) > 0 ))
      {error, _exit_code} ->
        Logger.error("Error while trying to get tags from repo '#{name}': #{error}")
        []
    end
  end

  def latest_tag(name, glob \\ "prod-*") do
    case System.cmd("git", ~w"--git-dir=services/#{name}/.git describe --match #{glob} --abbrev=0 origin/master", stderr_to_stdout: true) do
      {version, 0} -> version
        |> String.split("\n")
        |> Enum.map(&( String.trim(&1) ))
        |> Enum.filter(&( String.length(&1) > 0 ))
        |> Enum.map(&( String.trim(&1, "prod-") ))
        |> Enum.map(&( to_semver(&1) ))
        |> List.last
      {error, _exit_code} ->
        #Logger.error("Error while trying to get latest version from repo '#{name}': #{error}")
        []
    end
  end

  def latest_version(name) do
    tags(name)
    |> Enum.map(&( String.trim(&1, "prod-") ))
    |> Enum.map(&( to_semver(&1) ))
    |> Enum.max_by(&( numeric_semver(&1) ))
  end

  defp to_semver(string) do
    case String.split(string, ".") do
      [major, minor, patch] ->
        %{major: String.to_integer(major), minor: String.to_integer(minor), patch: String.to_integer(patch)}
      _ -> %{major: 0, minor: 0, patch: 0}
    end
  end

  defp numeric_semver(%{major: major, minor: minor, patch: patch}) do
    (major*1000000)+(minor*1000)+(patch)
  end

end
