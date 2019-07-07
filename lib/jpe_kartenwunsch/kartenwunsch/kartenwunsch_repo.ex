defmodule JpeKartenwunsch.KartenwunschRepo do
  alias JpeKartenwunsch.Kartenwunsch

  @spec web_dto_to_domain(Ecto.Changeset.t(), String.t()) :: %Kartenwunsch{}
  def web_dto_to_domain(
        %Ecto.Changeset{
          valid?: true,
          changes: %{
            name: name,
            normalpreis: normalpreis,
            ermaessigt: ermaessigt,
            schueler: schueler,
            instrumentengruppe: instrumentengruppe,
            created: _created,
            unique_id: unique_id
          }
        },
        full_path
      ) do
    {current_time, _} = get_metadata(full_path)

    %Kartenwunsch{
      name: name,
      normalpreis: normalpreis,
      ermaessigt: ermaessigt,
      schueler: schueler,
      instrumentengruppe: instrumentengruppe,
      created: current_time,
      unique_id: unique_id
    }
  end

  @spec web_dto_to_domain(Ecto.Changeset.t(), String.t()) :: %Kartenwunsch{}
  def web_dto_to_domain(
        %Ecto.Changeset{
          valid?: true,
          changes: %{
            name: name,
            normalpreis: normalpreis,
            ermaessigt: ermaessigt,
            schueler: schueler,
            instrumentengruppe: instrumentengruppe
          }
        },
        full_path
      ) do
    {current_time, new_id} = get_metadata(full_path)

    %Kartenwunsch{
      name: name,
      normalpreis: normalpreis,
      ermaessigt: ermaessigt,
      schueler: schueler,
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

  @spec get_internal_sorted((any() -> bool()), String.t()) :: [Kartenwunsch.t()]
  defp get_internal_sorted(filterFn, full_path) do
    load_lines(full_path)
    |> Enum.filter(&filterFn.(&1))
    |> Enum.sort(&(NaiveDateTime.compare(&1.created, &2.created) == :gt))
  end

  @spec insert(Kartenwunsch, String.t()) :: none()
  def insert(kartenwunsch = %Kartenwunsch{}, full_path) do
    {:ok, encoded} = Jason.encode(kartenwunsch)
    File.write(full_path, encoded <> "\r\n", [:append])
  end

  defp get_metadata(full_path) do
    {:ok, now} = DateTime.now("Europe/Berlin", Tzdata.TimeZoneDatabase)
    current_time = DateTime.to_naive(now)

    existing_ids = get_existing_ids(full_path)

    all_ids =
      for letter <- ["A", "B", "C", "D", "E", "F"], number <- 00000..99999 do
        "#{letter}#{String.pad_leading(Integer.to_string(number), 5, "0")}"
      end
      |> MapSet.new()

    valid_ids = MapSet.difference(all_ids, existing_ids)

    new_id = Enum.random(valid_ids)

    {current_time, new_id}
  end

  @spec get_existing_ids(String.t()) :: [String.t()]
  defp get_existing_ids(full_path) do
    load_lines(full_path)
    |> Enum.map(fn line ->
      %Kartenwunsch{unique_id: unique_id} = line
      unique_id
    end)
    |> MapSet.new()
  end

  @spec load_lines(String.t()) :: [%Kartenwunsch{}]
  defp load_lines(full_path) do
    if is_nil(full_path) do
      raise "full_path is nil, please set ENVVAR JPE_KARTENWUNSCH_DATABASE_FILE"
    else
      convert_storage_to_domain(File.read(full_path))
    end
  end

  defp convert_storage_to_domain({:ok, content}) do
    String.split(content, "\r\n")
    |> Enum.filter(&(String.length(&1) != 0))
    |> Enum.map(fn line ->
      {:ok, %{} = kw} = Jason.decode(line)
      to_domain(kw)
    end)
  end

  defp convert_storage_to_domain({:error, :enoent}) do
    IO.puts("load_lines -> convert_storage_to_domain: database file does not exist")
    []
  end

  @spec to_domain(%{}) :: %Kartenwunsch{}
  defp to_domain(from_storage) do
    %Kartenwunsch{
      name: from_storage["name"],
      instrumentengruppe: to_instrumentengruppe(from_storage["instrumentengruppe"]),
      normalpreis: from_storage["normalpreis"],
      ermaessigt: from_storage["ermaessigt"],
      schueler: from_storage["schueler"],
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
    end
  end
end
