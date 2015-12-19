defmodule Codemash2016.Game do
  use Timex

  # Structure
  # { game_code: "ABC123", player_one: {"Name", "scissors"}, player_two: {"Name", "rock"} }
 
  defstruct game_code: nil, player_one: {nil, nil}, player_two: {nil, nil}

  def generate_game_code do
    :crypto.hash(:sha256, Integer.to_string(Time.now(:usecs)))
    |> Base.encode16
    |> String.slice(0, 5)
    |> String.upcase
  end
end
