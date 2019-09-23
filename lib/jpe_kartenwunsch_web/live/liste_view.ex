defmodule JpeKartenwunschWeb.ListeView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <section id="liste">
    <table>
    <thead>
      <tr>
        <td>Instrumentengruppe</td>
        <td>Normalpreis</td>
        <td>Ermäßigt</td>
        <td>Schüler</td>
        <td>Freikarte für Geflüchtete</td>
      </tr>
    </thead>
    <tbody>
    <%= for entry <- @summen_by_instrumentengruppe do %>
      <tr>
        <td><%= prettify_instrumentengruppe(entry.instrumentengruppe) %></td>
        <td><%= entry.normalpreis %></td>
        <td><%= entry.ermaessigt %></td>
        <td><%= entry.schueler %></td>
        <td><%= entry.freikarte_gefluechtete %></td>
      </tr>
      <% end %>
      <tr>
        <td>GESAMTSUMME</td>
        <td><%= @gesamtsumme.normalpreis %></td>
        <td><%= @gesamtsumme.ermaessigt %></td>
        <td><%= @gesamtsumme.schueler %></td>
        <td><%= @gesamtsumme.freikarte_gefluechtete %></td>
      </tr>
    </tbody>
    </table>
    <table>
    <thead>
      <tr>
        <td>Name</td>
        <td>Instrumentengruppe</td>
        <td>Normal</td>
        <td>Ermäßigt</td>
        <td>Schüler</td>
        <td>Freikarte für Geflüchtete</td>
        <td>Zuletzt geändert</td>
        <td>Nummer</td>
      </tr>
    </thead>

    <tbody>
       <%= for entry <- @data do %>
        <tr>
          <td><%= entry.name %></td>
          <td><%= prettify_instrumentengruppe(entry.instrumentengruppe) %></td>
          <td><%= entry.normalpreis %></td>
          <td><%= entry.ermaessigt %></td>
          <td><%= entry.schueler %></td>
          <td><%= entry.freikarte_gefluechtete %></td>
          <td><%= prettify_date(entry.created) %></td>
          <td><%= entry.unique_id%></td>
        </tr>
      <% end %>
    </tbody>
    </table>
    </section>
    """
  end

  def mount(_session, socket) do
    page_data = JpeKartenwunsch.Liste.PageData.get_data()

    {:ok,
     assign(socket,
       data: page_data.data,
       summen_by_instrumentengruppe: page_data.summen_by_instrumentengruppe,
       gesamtsumme: page_data.gesamtsumme
     )}
  end

  def prettify_date(iso_date) do
    ndt = NaiveDateTime.from_iso8601!(iso_date)

    date = "#{pad_num_2(ndt.day)}.#{pad_num_2(ndt.month)}.#{ndt.year}"
    time = "#{pad_num_2(ndt.hour)}:#{pad_num_2(ndt.minute)} Uhr"

    "#{date} - #{time}"
  end

  def prettify_instrumentengruppe(instrumentengruppe) do
    case instrumentengruppe do
      :violine1 -> "Violine I"
      :violine2 -> "Violine II"
      :viola -> "Viola"
      :cello -> "Cello"
      :kontrabass -> "Kontrabass"
      :blaeser_und_schlagwerk -> "Bläser und Schlagwerk"
      :dirigent -> "Dirigent"
      :solist -> "Solist"
      :aushilfe -> "Aushilfe"
    end
  end

  @spec pad_num_2(integer()) :: String.t()
  defp pad_num_2(num) do
    "#{String.pad_leading(Integer.to_string(num), 2, "0")}"
  end
end
