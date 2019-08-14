defmodule JpeKartenwunsch.Ids.FileHandler do
  @id_file "ids.txt"

  def exists?(), do: File.exists?(@id_file)

  def load_ids() do
    File.read!(@id_file)
    |> String.split()
  end

  @spec save_ids([String.t()]) :: [String.t()]
  def save_ids(ids) do
    as_one_string = Enum.join(ids, "\r\n")

    File.write!(@id_file, as_one_string)

    ids
  end
end
