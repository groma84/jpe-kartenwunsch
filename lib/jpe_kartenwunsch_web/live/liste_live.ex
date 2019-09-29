defmodule JpeKartenwunschWeb.ListeLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(JpeKartenwunschWeb.ListeView, "index.html", assigns)
  end

  def mount(_session, socket) do
    page_data = JpeKartenwunsch.Liste.PageData.get_data()

    {:ok,
     assign(socket,
       last_sort_direction: "",
       data: page_data.data,
       summen_by_instrumentengruppe: page_data.summen_by_instrumentengruppe,
       gesamtsumme: page_data.gesamtsumme
     )}
  end

  def handle_event("sort_by", %{"field" => field}, socket) do
    %{last_sort_direction: last_sort_direction} = socket.assigns

    sort_direction =
      case last_sort_direction do
        "" -> "ascending"
        "ascending" -> "descending"
        "descending" -> "ascending"
      end

    page_data_sorted = JpeKartenwunsch.Liste.PageData.get_data_sorted(field, sort_direction)

    {:noreply, assign(socket, data: page_data_sorted, last_sort_direction: sort_direction)}
  end
end
