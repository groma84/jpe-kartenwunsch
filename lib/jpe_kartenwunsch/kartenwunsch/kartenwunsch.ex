defmodule JpeKartenwunsch.Kartenwunsch do
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

  @derive Jason.Encoder

  defstruct name: nil,
            instrumentengruppe: nil,
            normalpreis: 0,
            ermaessigt: 0,
            schueler: 0,
            unique_id: nil,
            created: nil

  @type t() :: %__MODULE__{
          name: name(),
          instrumentengruppe: Instrumentengruppe.instrumentengruppe(),
          normalpreis: Kartenanzahl.kartenanzahl(),
          ermaessigt: Kartenanzahl.kartenanzahl(),
          schueler: Kartenanzahl.kartenanzahl(),
          unique_id: unique_id(),
          created: NaiveDateTime.t()
        }
end
