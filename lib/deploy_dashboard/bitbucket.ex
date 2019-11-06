defmodule DeployDashboard.Bitbucket do
  require Logger

  def get_pull_requests(service) do
    case get_config(service) do
      %{"bitbucket_auth" => auth, "bitbucket_url" => url} -> pull_requests(auth, url)
      _ -> []
    end
  end

  defp get_config(service) do
    path = Path.join(File.cwd!(), "services/#{service}/.deploy_dashboard.yml")
    case YamlElixir.read_from_file(path) do
      {:ok, config} -> config
      {:error, %YamlElixir.FileNotFoundError{message: _msg}} -> %{}
    end
  end

  defp pull_requests(auth, url) do
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(
      url,
      ["Content-Type": "application/json", "Authorization": "Basic #{auth}"],
      [hackney: [:insecure]] # don't check certificates
    )
    body |> Poison.decode! |> Map.get("values")
    |> Enum.filter(&( String.contains?(String.downcase(&1["title"]), "next") ))
    |> Enum.map(&( Map.take(&1, ["title", "properties", "fromRef"]) ))
    |> Enum.map(&( Map.put(&1, "properties", &1["properties"]["mergeResult"]["outcome"]) )) # just take the outcome value
    |> Enum.map(&( Map.put(&1, "fromRef", &1["fromRef"]["displayId"]) )) # just take the displayId value
    #|> Enum.map(fn ({k, v}) -> {String.to_atom(k), v} end)
  end

end
