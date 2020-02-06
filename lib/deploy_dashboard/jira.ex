defmodule DeployDashboard.Jira do
  require Logger

  @fallback_response 0

  def blocker() do
    case get_config() do
      %{"jira_base_url" => base_url, "jira_blocker_query" => jql} -> tasks_count(base_url, jql)
      _ -> @fallback_response
    end
  end

  defp tasks_count(base_url, jql) do
    case search(base_url, jql) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body |> Poison.decode! |> Map.get("total")
      {:error, %HTTPoison.Error{reason: _reason}} ->
        @fallback_response
    end
  end

  def search(base_url, jql) do
    HTTPoison.get(
      "#{base_url}/rest/api/latest/search?jql=#{jql}",
      ["Content-Type": "application/json"],
      [hackney: [:insecure]] # don't check certificates
    )
  end


  defp get_config() do
    path = Path.join(File.cwd!(), ".jira.yml")
    case YamlElixir.read_from_file(path) do
      {:ok, config} -> config
      {:error, %YamlElixir.FileNotFoundError{message: _msg}} -> %{}
    end
  end
end
