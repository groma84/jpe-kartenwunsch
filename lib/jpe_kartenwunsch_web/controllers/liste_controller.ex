defmodule JpeKartenwunschWeb.ListeController do
  use JpeKartenwunschWeb, :controller

  alias JpeKartenwunsch.KartenwunschRepo
  alias JpeKartenwunsch.Kartenwunsch.WebDto

  def index(conn, _params) do
    full_path = JpeKartenwunsch.Path.FilePath.get_file_path()

    valid_entries =
      KartenwunschRepo.get_all(full_path)
      |> Enum.group_by(fn x -> x.unique_id end)
      |> Enum.map(fn {_key, lis} ->
        lis
        |> Enum.dedup_by(fn x -> x.unique_id end)
        |> Enum.at(0)
      end)
      |> Enum.sort(&(NaiveDateTime.compare(&1.created, &2.created) == :gt))

    data =
      valid_entries
      |> WebDto.from_domain()

    summen_by_instrumentengruppe =
      valid_entries
      |> JpeKartenwunsch.Liste.Sum.summe_by_instrumentengruppe()

    gesamtsumme =
      valid_entries
      |> JpeKartenwunsch.Liste.Sum.gesamtsumme()

    render(conn, "index.html",
      data: data,
      summen_by_instrumentengruppe: summen_by_instrumentengruppe,
      gesamtsumme: gesamtsumme
    )
  end
end
