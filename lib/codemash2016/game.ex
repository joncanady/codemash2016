defmodule Codemash2016.Game do
  use Timex

  @valid_moves {:rock, :paper, :scissors}

  defstruct game_code: nil, player_one_name: nil, player_one_move: nil, player_two_name: nil, player_two_move: nil, started: false

  def generate_game_code do
    :crypto.hash(:sha256, Integer.to_string(Time.now(:usecs)))
    |> Base.encode16
    |> String.slice(0, 5)
    |> String.upcase
  end

  @doc"""
  Returns true if the `game` is missing either player, false otherwise.
  """
  def waiting_for_players?(game) do
    is_nil(player_one_name(game)) or is_nil(player_two_name(game))
  end

  @doc"""
  Returns true if both players have joined. Inverse of `waiting_for_players?`
  """
  def all_players_joined?(game) do
    !waiting_for_players?(game)
  end

  @doc"""
  Returns player one's name, or nil if player one hasn't joined.
  """
  def player_one_name(game) do
    game.player_one_name
  end

  @doc"""
  Returns player two's name, or nil if player two hasn't joined.
  """
  def player_two_name(game) do
    game.player_two_name
  end

  @doc"""
  Adds a player named `name` into the player one slot on `game`
  """
  def add_player(game, "player_one", name) do
    %{game | player_one_name: name}
  end

  @doc"""
  Adds a player named `name` into the player two slot on `game`
  """
  def add_player(game, "player_two", name) do
    %{game | player_two_name: name}
  end
end
