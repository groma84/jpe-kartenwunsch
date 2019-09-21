defmodule JpeKartenwunsch.Liste.Sum do
  alias JpeKartenwunsch.Liste.Summen
  alias JpeKartenwunsch.Kartenwunsch

  def summe_by_instrumentengruppe(entries) do
    entries
    |> Enum.group_by(fn x -> x.instrumentengruppe end)
    |> Enum.map(fn {key, items} ->
      Map.merge(%{instrumentengruppe: key}, summe(items))
    end)
  end

  @spec gesamtsumme([Kartenwunsch.t()]) :: %Summen{}
  def gesamtsumme(entries) do
    summe(entries)
  end

  @spec summe([Kartenwunsch.t()]) :: %Summen{}
  defp summe(items) do
    %Summen{
      normalpreis: Enum.map(items, fn item -> item.normalpreis end) |> Enum.sum(),
      ermaessigt: Enum.map(items, fn item -> item.ermaessigt end) |> Enum.sum(),
      schueler: Enum.map(items, fn item -> item.schueler end) |> Enum.sum(),
      freikarte_gefluechtete:
        Enum.map(items, fn item -> item.freikarte_gefluechtete end) |> Enum.sum()
    }
  end
end
