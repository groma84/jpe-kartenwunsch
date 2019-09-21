defmodule JpeKartenwunsch.KartenwunschRepo do
  alias JpeKartenwunsch.Kartenwunsch

  @spec web_dto_to_domain(Ecto.Changeset.t(), String.t(), NaiveDateTime.t()) :: %Kartenwunsch{}
  def web_dto_to_domain(
        %Ecto.Changeset{
          valid?: true,
          changes: %{
            name: name,
            normalpreis: normalpreis,
            ermaessigt: ermaessigt,
            schueler: schueler,
            freikarte_gefluechtete: freikarte_gefluechtete,
            instrumentengruppe: instrumentengruppe,
            created: _created,
            unique_id: unique_id
          }
        },
        _full_path,
        current_time
      ) do
    %Kartenwunsch{
      name: name,
      normalpreis: normalpreis,
      ermaessigt: ermaessigt,
      schueler: schueler,
      freikarte_gefluechtete: freikarte_gefluechtete,
      instrumentengruppe: instrumentengruppe,
      created: current_time,
      unique_id: unique_id
    }
  end

  def web_dto_to_domain(
        %Ecto.Changeset{
          valid?: true,
          changes: %{
            name: name,
            normalpreis: normalpreis,
            ermaessigt: ermaessigt,
            schueler: schueler,
            freikarte_gefluechtete: freikarte_gefluechtete,
            instrumentengruppe: instrumentengruppe
          }
        },
        full_path,
        current_time
      ) do
    new_id = get_metadata(full_path)

    %Kartenwunsch{
      name: name,
      normalpreis: normalpreis,
      ermaessigt: ermaessigt,
      schueler: schueler,
      freikarte_gefluechtete: freikarte_gefluechtete,
      instrumentengruppe: instrumentengruppe,
      created: current_time,
      unique_id: new_id
    }
  end

  @spec get_all(String.t()) :: [Kartenwunsch.t()]
  def get_all(full_path) do
    get_internal_sorted(fn _ -> true end, full_path)
  end

  @spec get(Kartenwunsch.unique_id(), String.t()) :: [Kartenwunsch.t()]
  def get(unique_id, full_path) do
    get_internal_sorted(fn kw -> kw.unique_id == unique_id end, full_path)
  end

  @spec insert(%Kartenwunsch{}, String.t()) :: :ok
  def insert(kartenwunsch = %Kartenwunsch{}, full_path) do
    {:ok, encoded} = Jason.encode(kartenwunsch)
    JpeKartenwunsch.Persistence.FileStorage.write(encoded, full_path)
  end

  @spec get_internal_sorted((any() -> bool()), String.t()) :: [Kartenwunsch.t()]
  defp get_internal_sorted(filterFn, full_path) do
    load_lines(full_path)
    |> convert_storage_to_domain()
    |> Enum.filter(&filterFn.(&1))
    |> Enum.sort(&(NaiveDateTime.compare(&1.created, &2.created) == :gt))
  end

  defp get_metadata(full_path) do
    existing_ids = get_existing_ids(full_path)

    all_ids = JpeKartenwunsch.Ids.IdManager.get_all_possible()

    valid_ids = MapSet.difference(all_ids, existing_ids)

    new_id = Enum.random(valid_ids)
    new_id
  end

  @spec get_existing_ids(String.t()) :: MapSet.t(String.t())
  defp get_existing_ids(full_path) do
    load_lines(full_path)
    |> convert_storage_to_domain()
    |> Enum.map(fn line ->
      %Kartenwunsch{unique_id: unique_id} = line
      unique_id
    end)
    |> MapSet.new()
  end

  @spec load_lines(String.t()) :: [String.t()]
  defp load_lines(full_path) do
    JpeKartenwunsch.Persistence.FileStorage.load(full_path)
  end

  @spec convert_storage_to_domain([String.t()]) :: [%Kartenwunsch{}]
  defp convert_storage_to_domain(lines) do
    lines
    |> Enum.filter(&(String.length(&1) != 0))
    |> Enum.map(fn line ->
      {:ok, %{} = kw} = Jason.decode(line)
      to_domain(kw)
    end)
  end

  @spec to_domain(%{}) :: %Kartenwunsch{}
  defp to_domain(from_storage) do
    %Kartenwunsch{
      name: from_storage["name"],
      instrumentengruppe: to_instrumentengruppe(from_storage["instrumentengruppe"]),
      normalpreis: from_storage["normalpreis"],
      ermaessigt: from_storage["ermaessigt"],
      schueler: from_storage["schueler"],
      freikarte_gefluechtete: from_storage["freikarte_gefluechtete"],
      unique_id: from_storage["unique_id"],
      created: NaiveDateTime.from_iso8601!(from_storage["created"])
    }
  end

  @spec to_instrumentengruppe(String.t()) :: Kartenwunsch.instrumentengruppe()
  defp to_instrumentengruppe(as_string) do
    case as_string do
      "violine1" -> :violine1
      "violine2" -> :violine2
      "viola" -> :viola
      "cello" -> :cello
      "kontrabass" -> :kontrabass
      "blaeser_und_schlagwerk" -> :blaeser_und_schlagwerk
      "dirigent" -> :dirigent
      "solist" -> :solist
      "aushilfe" -> :aushilfe
    end
  end
end
