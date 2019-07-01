defmodule JpeKartenwunsch.Kartenwunsch do
  @type kartenanzahl() :: 0..20
  @type instrumentengruppe() ::
          :violine1 | :violine2 | :viola | :cello | :kontrabass | :blaeser_und_schlagwerk
  @type name() :: String.t()
  @type unique_id() :: String.t()

  @enforce_keys [
    :name,
    :instrumentengruppe,
    :normalpreis,
    :ermaessigt,
    :schueler,
    :unique_id,
    :created
  ]

  defstruct name: nil,
            instrumentengruppe: nil,
            normalpreis: 0,
            ermaessigt: 0,
            schueler: 0,
            unique_id: nil,
            created: nil

  @type t() :: %__MODULE__{
          name: name(),
          instrumentengruppe: instrumentengruppe(),
          normalpreis: kartenanzahl(),
          ermaessigt: kartenanzahl(),
          schueler: kartenanzahl(),
          unique_id: unique_id(),
          created: NaiveDateTime.t()
        }
end
