defmodule JpeKartenwunsch.Kartenwunsch.WebDto do
  use Ecto.Schema
  import Ecto.Changeset
  alias JpeKartenwunsch.Kartenwunsch.WebDto

  embedded_schema do
    field(:created, :naive_datetime)
    field(:ermaessigt, :integer)
    field(:unique_id, :string)
    field(:name, :string)
    field(:instrumentengruppe, :string)
    field(:schueler, :integer)
    field(:normalpreis, :integer)
  end

  @changeset_keys [
    :name,
    :instrumentengruppe,
    :normalpreis,
    :ermaessigt,
    :schueler,
    :unique_id,
    :created
  ]

  @spec empty_changeset() :: Ecto.Changeset.t()
  def empty_changeset() do
    cast(
      %WebDto{},
      %{
        name: "",
        normalpreis: 0,
        ermaessigt: 0,
        schueler: 0,
        unique_id: nil,
        created: nil,
        instrumentengruppe: "violine1"
      },
      @changeset_keys
    )
  end

  @spec create_new(%{}) :: Ecto.Changeset.t()
  def create_new(attrs), do: changeset(%WebDto{}, attrs)

  @spec from_domain([%JpeKartenwunsch.Kartenwunsch{}]) :: [%WebDto{}]
  def from_domain(kartenwünsche), do: Enum.map(kartenwünsche, &transform_one_domain_to_data/1)

  @spec to_changeset(%{}) :: Ecto.Changeset.t()
  def to_changeset(kundenwunsch_map), do: changeset(%WebDto{}, kundenwunsch_map)

  defp transform_one_domain_to_data(from_domain) do
    %{
      name: from_domain.name,
      instrumentengruppe: from_domain.instrumentengruppe,
      normalpreis: from_domain.normalpreis,
      ermaessigt: from_domain.ermaessigt,
      schueler: from_domain.schueler,
      unique_id: from_domain.unique_id,
      created: NaiveDateTime.to_iso8601(from_domain.created)
    }
  end

  @doc false
  defp changeset(%WebDto{} = web_dto, attrs) do
    web_dto
    |> cast(attrs, @changeset_keys)
    |> validate_required([:name, :normalpreis, :ermaessigt, :schueler, :instrumentengruppe])
    |> validate_length(:name, min: 2, max: 150)
    |> validate_number(:normalpreis, greater_than: -1, less_than: 21)
    |> validate_number(:ermaessigt, greater_than: -1, less_than: 21)
    |> validate_number(:schueler, greater_than: -1, less_than: 21)
  end
end
