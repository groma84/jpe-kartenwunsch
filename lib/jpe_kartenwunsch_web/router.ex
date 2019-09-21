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

    get "/kartenwunsch/:id/edit", KartenwunschController, :edit
    post "/kartenwunsch/", KartenwunschController, :create
    post "/kartenwunsch/:id", KartenwunschController, :update

    post "/bestehend/", BestehendController, :redirect_to_edit

    get "/liste/", ListeController, :index

    get "/datenschutz/", DatenschutzController, :index
    get "/impressum/", ImpressumController, :index

    # resources "/kartenwunsch", KartenwunschController, only: [:create, :edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", JpeKartenwunschWeb do
  #   pipe_through :api
  # end
end
