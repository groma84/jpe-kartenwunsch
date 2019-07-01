defmodule JpeKartenwunsch.KartenwunschRepo do
  @spec web_dto_to_domain(Ecto.Changeset.t()) :: %JpeKartenwunsch.Kartenwunsch{}
  def web_dto_to_domain(%Ecto.Changeset{
        valid?: true,
        changes: %{
          name: name,
          normalpreis: normalpreis,
          ermaessigt: ermaessigt,
          schueler: schueler,
          instrumentengruppe: instrumentengruppe
        }
      }) do
    {current_time, new_id} = get_metadata()

    %JpeKartenwunsch.Kartenwunsch{
      name: name,
      normalpreis: normalpreis,
      ermaessigt: ermaessigt,
      schueler: schueler,
      instrumentengruppe: instrumentengruppe,
      created: current_time,
      unique_id: new_id
    }
  end

  defp get_metadata() do
    {:ok, now} = DateTime.now("Europe/Berlin", Tzdata.TimeZoneDatabase)
    current_time = DateTime.to_naive(now)

    existing_ids = get_existing_ids()

    all_ids =
      for letter <- ["A", "B", "C"], number <- 00000..99999 do
        "#{letter}#{number}"
      end
      |> MapSet.new()

    valid_ids = MapSet.difference(all_ids, existing_ids)

    new_id = Enum.random(valid_ids)

    {current_time, new_id}
  end

  def insert(kartenwunsch = %JpeKartenwunsch.Kartenwunsch{}) do
    IO.inspect(kartenwunsch)
  end

  defp get_existing_ids() do
    # TODO
    MapSet.new()
  end
end
