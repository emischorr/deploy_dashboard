defmodule DeployDashboardWeb.Router do
  use DeployDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DeployDashboardWeb.Plug.AllowIframe
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeployDashboardWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/dashboard", PageController, :dashboard
    get "/:service", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", DeployDashboardWeb do
  #   pipe_through :api
  # end
end
