defmodule JpeKartenwunschWeb.ListeLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(JpeKartenwunschWeb.ListeView, "index.html", assigns)
  end

  def mount(_session, socket) do
    page_data = JpeKartenwunsch.Liste.PageData.get_data()

    vorverkauf_aktiv =
      JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(
        JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
      )

    {:ok,
     assign(socket,
       last_sort_direction: "",
       data: page_data.data,
       summen_by_instrumentengruppe: page_data.summen_by_instrumentengruppe,
       gesamtsumme: page_data.gesamtsumme,
       vorverkauf_aktiv: vorverkauf_aktiv,
       admin_password_wrong: false
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

  def handle_event(
        "toggle_vorverkauf",
        %{"admin" => %{"admin_password" => admin_password}},
        socket
      ) do
    admin_password_wrong =
      !JpeKartenwunsch.Administration.Admin.check_admin_password(admin_password)

    full_path = JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
    vorverkauf_aktiv = JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(full_path)

    new_socket =
      if admin_password_wrong do
        assign(socket, admin_password_wrong: true)
      else
        if vorverkauf_aktiv do
          JpeKartenwunsch.Administration.Admin.deactivate_vorverkauf(full_path)
        else
          JpeKartenwunsch.Administration.Admin.activate_vorverkauf(full_path)
        end

        vorverkauf_aktiv_changed =
          JpeKartenwunsch.Administration.Admin.vorverkauf_aktiv(
            JpeKartenwunsch.Path.FilePath.get_vorverkauf_file_path()
          )

        assign(socket, admin_password_wrong: false, vorverkauf_aktiv: vorverkauf_aktiv_changed)
      end

    {:noreply, new_socket}
  end
end
