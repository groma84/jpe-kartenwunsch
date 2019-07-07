defmodule JpeKartenwunsch.DatabaseFilePath do
  def get_file_path(), do: Application.get_env(:jpe_kartenwunsch, :database_file)
end
