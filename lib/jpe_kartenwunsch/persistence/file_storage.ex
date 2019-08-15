defmodule JpeKartenwunsch.Persistence.FileStorage do
  @spec load(String.t()) :: [String.t()]
  def load(full_path) do
    if is_nil(full_path) do
      raise "full_path is nil, please set ENVVAR JPE_KARTENWUNSCH_DATABASE_FILE"
    else
      JpeKartenwunsch.Persistence.Serializer.read(fn ->
        case File.read(full_path) do
          {:ok, content} ->
            String.split(content, "\r\n")

          {:error, :enoent} ->
            IO.puts("database file does not exist: #{full_path}")
            []
        end
      end)
    end
  end

  @spec write(String.t(), String.t()) :: :ok
  def write(encoded, full_path) do
    JpeKartenwunsch.Persistence.Serializer.write(fn ->
      File.write!(full_path, encoded <> "\r\n", [:append])
    end)
  end
end
