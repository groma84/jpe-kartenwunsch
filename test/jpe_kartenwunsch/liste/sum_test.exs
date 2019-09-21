defmodule JpeKartenwunsch.Liste.SumTest do
  use ExUnit.Case, async: true
  alias JpeKartenwunsch.Kartenwunsch
  alias JpeKartenwunsch.Liste.Sum
  alias JpeKartenwunsch.Liste.Summen

  @kartenwunsch1 %Kartenwunsch{
    name: "kartenwunsch1",
    instrumentengruppe: :violine1,
    normalpreis: 1,
    ermaessigt: 1,
    schueler: 1,
    freikarte_gefluechtete: 1,
    unique_id: "kartenwunsch1",
    created: NaiveDateTime.utc_now()
  }

  @kartenwunsch2 %Kartenwunsch{
    name: "kartenwunsch2",
    instrumentengruppe: :violine2,
    normalpreis: 1,
    ermaessigt: 1,
    schueler: 1,
    freikarte_gefluechtete: 1,
    unique_id: "kartenwunsch2",
    created: NaiveDateTime.utc_now()
  }

  test "A sum of no items is empty" do
    assert Sum.gesamtsumme([]) == %Summen{
             normalpreis: 0,
             ermaessigt: 0,
             schueler: 0,
             freikarte_gefluechtete: 0
           }
  end

  test "A sum of one entries contains that entry's numbers" do
    assert Sum.gesamtsumme([@kartenwunsch1]) == %Summen{
             normalpreis: 1,
             ermaessigt: 1,
             schueler: 1,
             freikarte_gefluechtete: 1
           }
  end

  test "A sum of multiple entries sums the numbers" do
    assert Sum.gesamtsumme([@kartenwunsch1, @kartenwunsch1]) == %Summen{
             normalpreis: 2,
             ermaessigt: 2,
             schueler: 2,
             freikarte_gefluechtete: 2
           }
  end

  test "A sum of multiple entries in one instrumentengruppe contains correct sum" do
    assert Sum.summe_by_instrumentengruppe([@kartenwunsch1, @kartenwunsch1]) ==
             [
               Map.merge(
                 %{instrumentengruppe: @kartenwunsch1.instrumentengruppe},
                 %Summen{
                   normalpreis: 2,
                   ermaessigt: 2,
                   schueler: 2,
                   freikarte_gefluechtete: 2
                 }
               )
             ]
  end

  test "A sum of multiple entries in multiple instrumentengruppen contains correct sums" do
    assert Sum.summe_by_instrumentengruppe([
             @kartenwunsch1,
             @kartenwunsch1,
             @kartenwunsch2,
             @kartenwunsch2
           ]) ==
             [
               Map.merge(
                 %{instrumentengruppe: @kartenwunsch1.instrumentengruppe},
                 %Summen{
                   normalpreis: 2,
                   ermaessigt: 2,
                   schueler: 2,
                   freikarte_gefluechtete: 2
                 }
               ),
               Map.merge(
                 %{instrumentengruppe: @kartenwunsch2.instrumentengruppe},
                 %Summen{
                   normalpreis: 2,
                   ermaessigt: 2,
                   schueler: 2,
                   freikarte_gefluechtete: 2
                 }
               )
             ]
  end
end
