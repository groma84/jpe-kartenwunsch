defmodule JpeKartenwunschWeb.KartenwunschController do
  use JpeKartenwunschWeb, :controller

  alias JpeKartenwunsch.Kartenwunsch.WebDto
  alias JpeKartenwunsch.KartenwunschRepo

  def create(conn, %{"new_kartenwunsch" => new_kartenwunsch}),
    do: create_or_update(conn, new_kartenwunsch, "gespeichert")

  def edit(conn, %{"id" => unique_id}) do
    from_persistence =
      KartenwunschRepo.get(unique_id, JpeKartenwunsch.Path.FilePath.get_file_path())

    case from_persistence do
      [] ->
        conn
        |> put_flash(
          :error,
          "Kartenwunsch mit der Nummer '#{unique_id}' wurde leider nicht gefunden."
        )
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        as_changeset =
          from_persistence
          |> WebDto.from_domain()
          # latest edit is enough
          |> Enum.at(0)
          |> WebDto.to_changeset()

        Phoenix.Controller.render(conn, "update.html",
          changeset: as_changeset,
          action: Routes.kartenwunsch_path(conn, :update, as_changeset.changes.unique_id),
          as: :edited_kartenwunsch,
          submit_text: "Aktualisieren",
          disabled:
            !JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(
              JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
            )
        )
    end
  end

  def update(conn, %{"edited_kartenwunsch" => edited_kartenwunsch}),
    do: create_or_update(conn, edited_kartenwunsch, "aktualisiert")

  def redirect_to_edit(conn, %{"unique_id" => unique_id}) do
    conn
    |> redirect(to: Routes.kartenwunsch_path(conn, :edit, unique_id))
  end

  defp create_or_update(conn, kartenwunsch, success_verb) do
    full_file_path = JpeKartenwunsch.Path.FilePath.get_file_path()
    vorverkauf_file_path = JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
    current_time = JpeKartenwunsch.Time.TimeGetter.now()

    kw =
      WebDto.create_new(kartenwunsch)
      |> KartenwunschRepo.web_dto_to_domain(full_file_path, current_time)

    vorverkauf_active =
      JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(vorverkauf_file_path)

    KartenwunschRepo.insert(kw, full_file_path, vorverkauf_active)

    conn
    |> put_flash(:info, "Kartenwunsch mit der Nummer '#{kw.unique_id}' wurde #{success_verb}")
    |> redirect(to: Routes.kartenwunsch_path(conn, :edit, kw.unique_id))
  end
end
