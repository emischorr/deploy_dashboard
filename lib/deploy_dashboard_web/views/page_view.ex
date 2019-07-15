defmodule DeployDashboardWeb.PageView do
  use DeployDashboardWeb, :view

  def semver(%{major: major, minor: minor, patch: patch}) do
    "#{major}.#{minor}.#{patch}"
  end
  def semver(%{}), do: "0.0.0"
  def semver([]), do: "0.0.0"
end
