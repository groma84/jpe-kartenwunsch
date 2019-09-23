defmodule JpeKartenwunschWeb.ImpressumController do
  use JpeKartenwunschWeb, :controller

  def index(conn, _params) do
    Phoenix.Controller.render(conn, "index.html")
  end
end
