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

  @doc"""
  Returns true if the `game` is missing either player.
  """
  def waiting_for_players?(game) do
    is_nil(player_one_name(game)) or is_nil(player_two_name(game))
  end

  @doc"""
  Returns player one's name, or nil if player one hasn't joined.
  """
  def player_one_name(game) do
    elem(game.player_one, 0)
  end

  @doc"""
  Returns player two's name, or nil if player two hasn't joined.
  """
  def player_two_name(game) do
    elem(game.player_two, 0)
  end
end
