defmodule JpeKartenwunsch.Administration.Admin do
  @spec check_admin_password(String.t()) :: boolean
  def check_admin_password(admin_password) do
    admin_password == "jpeadmin"
  end

  @spec vorverkauf_aktiv(String.t()) :: boolean
  def vorverkauf_aktiv(full_path) do
    lines = JpeKartenwunsch.Persistence.FileStorage.load(full_path)
    compare_vorverkauf_string(Enum.at(lines, 0, ""))
  end

  def activate_vorverkauf(full_path) do
    JpeKartenwunsch.Persistence.FileStorage.replace_content("true", full_path)
  end

  def deactivate_vorverkauf(full_path) do
    JpeKartenwunsch.Persistence.FileStorage.replace_content("false", full_path)
  end

  defp compare_vorverkauf_string(stored) do
    stored == "true"
  end
end
