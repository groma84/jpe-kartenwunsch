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

  def get_data_sorted(field, direction) do
    JpeKartenwunsch.Path.FilePath.get_file_path()
    |> get_valid_entries()
    |> sort_by(field, direction)
    |> WebDto.from_domain()
  end

  # TODO: Sorting is bugged -> write tests and fix!
  defp sort_by(entries, field, direction) do
    sort_direction_fn =
      case direction do
        "ascending" -> &Enum.sort/1
        "descending" -> &Enum.reverse/1
      end

    sort_field_fn =
      case field do
        "instrumentengruppe" ->
          &Enum.sort/1

        "created" ->
          &Enum.sort(&1, fn l, r -> sort_by_date(l, r, :lt) end)
      end

    sorted =
      entries
      |> sort_field_fn.()
      |> sort_direction_fn.()

    sorted
  end

  defp get_valid_entries(full_path) do
    KartenwunschRepo.get_all(full_path)
    |> Enum.group_by(fn x -> x.unique_id end)
    |> Enum.map(fn {_key, lis} ->
      lis
      |> Enum.dedup_by(fn x -> x.unique_id end)
      |> Enum.at(0)
    end)
    |> Enum.sort(&sort_by_date(&1, &2, :gt))
  end

  defp sort_by_date(entry1, entry2, compare_direction) do
    NaiveDateTime.compare(entry1.created, entry2.created) == compare_direction
  end
end
