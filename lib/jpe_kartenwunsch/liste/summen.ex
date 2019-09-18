defmodule JpeKartenwunsch.Liste.Summen do
  alias JpeKartenwunsch.Kartenwunsch.Kartenanzahl

  @enforce_keys [
    :normalpreis,
    :ermaessigt,
    :schueler
  ]

  defstruct normalpreis: 0,
            ermaessigt: 0,
            schueler: 0

  @type t() :: %__MODULE__{
          normalpreis: Kartenanzahl.kartenanzahl(),
          ermaessigt: Kartenanzahl.kartenanzahl(),
          schueler: Kartenanzahl.kartenanzahl()
        }
end
