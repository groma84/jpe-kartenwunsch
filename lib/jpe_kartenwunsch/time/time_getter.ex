defmodule JpeKartenwunsch.Time.TimeGetter do
  @spec now() :: NaiveDateTime.t()
  def now() do
    {:ok, now} = DateTime.now("Europe/Berlin", Tzdata.TimeZoneDatabase)
    DateTime.to_naive(now)
  end
end
