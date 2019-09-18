defmodule JpeKartenwunsch.Persistence.Serializer do
  use GenServer

  @impl true
  def init(_) do
    {:ok, :no_args}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  @spec read((() -> String.t())) :: [String.t()]
  def read(readFn) do
    GenServer.call(__MODULE__, {:read, readFn})
  end

  def write(writeFn) do
    GenServer.call(__MODULE__, {:write, writeFn})
  end

  @impl true
  def handle_call({:read, readFn}, _from, state) do
    {:reply, readFn.(), state}
  end

  @impl true
  def handle_call({:write, writeFn}, _from, state) do
    {:reply, writeFn.(), state}
  end
end
