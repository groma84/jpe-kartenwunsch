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
  def create_new(attrs) do
    changeset(%WebDto{}, attrs)
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
