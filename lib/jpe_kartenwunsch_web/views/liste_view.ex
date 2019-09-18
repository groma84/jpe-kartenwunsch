defmodule JpeKartenwunschWeb.ListeView do
  use JpeKartenwunschWeb, :view

  def prettify_date(iso_date) do
    ndt = NaiveDateTime.from_iso8601!(iso_date)

    date = "#{pad_num_2(ndt.day)}.#{pad_num_2(ndt.month)}.#{ndt.year}"
    time = "#{pad_num_2(ndt.hour)}:#{pad_num_2(ndt.minute)} Uhr"

    "#{date} - #{time}"
  end

  def prettify_instrumentengruppe(instrumentengruppe) do
    case instrumentengruppe do
      :violine1 -> "Violine I"
      :violine2 -> "Violine II"
      :viola -> "Viola"
      :cello -> "Cello"
      :kontrabass -> "Kontrabass"
      :blaeser_und_schlagwerk -> "Bläser und Schlagwerk"
    end
  end

  @spec pad_num_2(integer()) :: String.t()
  defp pad_num_2(num) do
    "#{String.pad_leading(Integer.to_string(num), 2, "0")}"
  end
end
