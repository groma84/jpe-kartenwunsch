defmodule JpeKartenwunschWeb.ListeController do
  use JpeKartenwunschWeb, :controller

  alias JpeKartenwunsch.KartenwunschRepo
  alias JpeKartenwunsch.Kartenwunsch.WebDto

  def index(conn, _params) do
    full_path = JpeKartenwunsch.DatabaseFilePath.get_file_path()

    data =
      KartenwunschRepo.get_all(full_path)
      |> Enum.group_by(fn x -> x.unique_id end)
      |> Enum.map(fn {_key, lis} ->
        lis
        |> Enum.dedup_by(fn x -> x.unique_id end)
        |> Enum.at(0)
      end)
      # |> Enum.flat_map(& &1)
      |> Enum.sort(&(NaiveDateTime.compare(&1.created, &2.created) == :gt))
      |> WebDto.from_domain()

    render(conn, "index.html", data: data)
  end
end
