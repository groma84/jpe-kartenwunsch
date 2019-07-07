defmodule JpeKartenwunschWeb.BestehendController do
  use JpeKartenwunschWeb, :controller

  def redirect_to_edit(conn, %{"unique_id" => unique_id}) do
    conn
    |> redirect(to: Routes.kartenwunsch_path(conn, :edit, unique_id))
  end
end
