defmodule JpeKartenwunsch.Liste.PageData do
  alias JpeKartenwunsch.KartenwunschRepo
  alias JpeKartenwunsch.Kartenwunsch.WebDto

  def get_data() do
    full_path = JpeKartenwunsch.Path.FilePath.get_file_path()

    valid_entries = get_valid_entries(full_path)

    data =
      valid_entries
      |> WebDto.from_domain()

    summen_by_instrumentengruppe =
      valid_entries
      |> JpeKartenwunsch.Liste.Sum.summe_by_instrumentengruppe()

    gesamtsumme =
      valid_entries
      |> JpeKartenwunsch.Liste.Sum.gesamtsumme()

    %{
      data: data,
      summen_by_instrumentengruppe: summen_by_instrumentengruppe,
      gesamtsumme: gesamtsumme
    }
  end

  def get_data_sorted(field, sort_direction_atom) do
    JpeKartenwunsch.Path.FilePath.get_file_path()
    |> get_valid_entries()
    |> sort_by(field, sort_direction_atom)
    |> WebDto.from_domain()
  end

  defp sort_by(entries, field, sort_direction_atom) do
    sort_field_fn =
      case field do
        "instrumentengruppe" ->
          &Enum.sort_by(&1, fn entry -> entry.instrumentengruppe end, sort_direction_atom)

        "created" ->
          &Enum.sort_by(&1, fn entry -> entry.created end, {sort_direction_atom, NaiveDateTime})
      end

    entries
    |> sort_field_fn.()
  end

  defp get_valid_entries(full_path) do
    KartenwunschRepo.get_all(full_path)
    |> Enum.group_by(& &1.unique_id)
    |> Enum.map(fn {_key, lis} ->
      lis
      |> Enum.dedup_by(& &1.unique_id)
      |> Enum.at(0)
    end)
    |> Enum.sort_by(& &1.created, {:desc, NaiveDateTime})
  end
end
