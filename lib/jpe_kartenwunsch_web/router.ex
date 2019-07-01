defmodule JpeKartenwunschWeb.Router do
  use JpeKartenwunschWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JpeKartenwunschWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/kartenwunsch", KartenwunschController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", JpeKartenwunschWeb do
  #   pipe_through :api
  # end
end
