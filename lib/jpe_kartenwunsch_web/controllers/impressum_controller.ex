defmodule JpeKartenwunschWeb.ImpressumController do
  use JpeKartenwunschWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
