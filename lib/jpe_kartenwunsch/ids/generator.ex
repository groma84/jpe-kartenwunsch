defmodule JpeKartenwunsch.Ids.Generator do
  def generate() do
    for letter <- ["A", "B", "C", "D", "E", "F"], number <- 00000..99999 do
      "#{letter}#{String.pad_leading(Integer.to_string(number), 5, "0")}"
    end
  end
end
