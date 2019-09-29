defmodule JpeKartenwunschWeb.PageController do
  use JpeKartenwunschWeb, :controller

  import JpeKartenwunsch.Kartenwunsch.WebDto

  def index(conn, _params) do
    Phoenix.Controller.render(conn, "index.html",
      changeset: empty_changeset(),
      action: Routes.kartenwunsch_path(conn, :create),
      as: :new_kartenwunsch,
      submit_text: "Absenden",
      disabled:
        !JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(
          JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
        )
    )
  end
end
