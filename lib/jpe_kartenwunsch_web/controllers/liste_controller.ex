defmodule JpeKartenwunschWeb.ListeController do
  use JpeKartenwunschWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, JpeKartenwunschWeb.ListeLive, session: %{})
  end
end
