defmodule JpeKartenwunschWeb.KartenwunschController do
  use JpeKartenwunschWeb, :controller

  alias JpeKartenwunsch.Kartenwunsch.WebDto
  alias JpeKartenwunsch.KartenwunschRepo

  def create(conn, %{"new_kartenwunsch" => new_kartenwunsch}),
    do: create_or_update(conn, new_kartenwunsch, "gespeichert")

  def edit(conn, %{"id" => unique_id}) do
    as_changeset =
      KartenwunschRepo.get(unique_id, JpeKartenwunsch.DatabaseFilePath.get_file_path())
      |> WebDto.from_domain()
      # latest edit is enough
      |> Enum.at(0)
      |> WebDto.to_changeset()

    render(conn, "update.html", changeset: as_changeset)
  end

  def update(conn, %{"edited_kartenwunsch" => edited_kartenwunsch}),
    do: create_or_update(conn, edited_kartenwunsch, "aktualisiert")

  def redirect_to_edit(conn, %{"unique_id" => unique_id}) do
    conn
    |> redirect(to: Routes.kartenwunsch_path(conn, :edit, unique_id))
  end

  defp create_or_update(conn, kartenwunsch, success_verb) do
    full_file_path = JpeKartenwunsch.DatabaseFilePath.get_file_path()
    current_time = JpeKartenwunsch.Time.TimeGetter.now()

    kw =
      WebDto.create_new(kartenwunsch)
      |> KartenwunschRepo.web_dto_to_domain(full_file_path, current_time)

    KartenwunschRepo.insert(kw, full_file_path)

    conn
    |> put_flash(:info, "Kartenwunsch mit der Nummer '#{kw.unique_id}' wurde #{success_verb}")
    |> redirect(to: Routes.kartenwunsch_path(conn, :edit, kw.unique_id))
  end
end
