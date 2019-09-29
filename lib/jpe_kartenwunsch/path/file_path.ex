defmodule JpeKartenwunsch.Path.FilePath do
  use Agent

  def start_link(_) do
    Agent.start_link(&get_file_path_from_env/0, name: __MODULE__)
  end

  @spec get_file_path() :: String.t()
  def get_file_path() do
    Agent.get(__MODULE__, fn base_path ->
      current_time = JpeKartenwunsch.Time.TimeGetter.now()

      file_name =
        "#{base_path}_#{current_time.year}_#{month_to_semester(current_time.month)}.db.txt"

      file_name
    end)
  end

  @spec get_vorverkauf_file_path() :: String.t()
  def get_vorverkauf_file_path() do
    Agent.get(__MODULE__, fn base_path ->
      "#{base_path}_vorverkauf_aktiv.txt"
    end)
  end

  defp get_file_path_from_env(), do: Application.get_env(:jpe_kartenwunsch, :database_file)

  @spec month_to_semester(pos_integer()) :: String.t()
  defp month_to_semester(month) do
    if 4 <= month && month <= 9 do
      "ss"
    else
      "ws"
    end
  end
end
