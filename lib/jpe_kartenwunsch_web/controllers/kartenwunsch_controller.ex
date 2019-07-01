defmodule JpeKartenwunschWeb.KartenwunschController do
  use JpeKartenwunschWeb, :controller

  import JpeKartenwunsch.Kartenwunsch.WebDto

  def create(conn, %{"new_kartenwunsch" => new_kartenwunsch}) do
    JpeKartenwunsch.Kartenwunsch.WebDto.create_new(new_kartenwunsch)
    |> JpeKartenwunsch.KartenwunschRepo.web_dto_to_domain()
    |> JpeKartenwunsch.KartenwunschRepo.insert()

    conn
    |> put_flash(:info, "Created")
    |> redirect(to: Routes.page_path(conn, :index))

    # |> redirect(​to:​ Routes.page_path(conn, ​:index​))
  end
end
