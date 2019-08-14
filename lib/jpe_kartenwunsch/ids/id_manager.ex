defmodule JpeKartenwunsch.Ids.IdManager do
  use Agent

  alias JpeKartenwunsch.Ids.{Generator, FileHandler}

  def start_link(_) do
    start_result = Agent.start_link(&MapSet.new/0, name: __MODULE__)

    Agent.cast(__MODULE__, fn _state ->
      get_ids()
    end)

    start_result
  end

  def get_all_possible() do
    Agent.get(__MODULE__, & &1)
  end

  defp get_ids() do
    if FileHandler.exists?() do
      FileHandler.load_ids()
      |> MapSet.new()
    else
      Generator.generate()
      |> FileHandler.save_ids()
      |> MapSet.new()
    end
  end
end
