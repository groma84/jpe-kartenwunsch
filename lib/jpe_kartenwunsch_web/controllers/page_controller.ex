defmodule JpeKartenwunschWeb.PageController do
  use JpeKartenwunschWeb, :controller

  import JpeKartenwunsch.Kartenwunsch.WebDto

  def index(conn, _params) do
    render(conn, "index.html", changeset: empty_changeset())
  end
end
