defmodule Codemash2016.Game do
  alias Codemash2016.Game
  use Timex

  @valid_moves {:rock, :paper, :scissors}
  @players     %{"player_one" => :player_one_move, "player_two" => :player_two_move}

  defstruct game_code: nil, player_one_name: nil, player_one_move: nil, player_two_name: nil, player_two_move: nil, started: false, outcome: nil

  def generate_game_code do
    :crypto.hash(:sha256, Integer.to_string(Time.now(:usecs)))
    |> Base.encode16
    |> String.slice(0, 5)
    |> String.upcase
  end

  @doc"""
  Returns true if the `game` is missing either player, false otherwise.
  """
  # def waiting_for_players?(game) do
  #   is_nil(player_one_name(game)) or is_nil(player_two_name(game))
  # end

  def waiting_for_players?(%Game{player_one_name: p1}) when is_nil(p1), do: true
  def waiting_for_players?(%Game{player_two_name: p2}) when is_nil(p2), do: true
  def waiting_for_players?(_game), do: false

  @doc"""
  Returns true if both players have joined. Inverse of `waiting_for_players?`
  """
  def all_players_joined?(game), do: !waiting_for_players?(game)

  @doc"""
  Returns player one's name, or nil if player one hasn't joined.
  """
  def player_one_name(game), do: game.player_one_name

  @doc"""
  Returns player two's name, or nil if player two hasn't joined.
  """
  def player_two_name(game), do: game.player_two_name

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

  @doc"""
  Makes `choice` for `player` in `game`.
  """
  def shoot(game, player, choice) do
    Map.put(game, move_string_to_atom(player), choice)
  end

  defp move_string_to_atom(string) do
    @players[string]
  end

  def set_started_flag(game = %Game{started: started}) when started, do: game
  def set_started_flag(game) do
    if all_players_joined?(game) do
      %{game | started: true}
    else
      game
    end
  end

  # SETTING OUTCOME

  ## NOOPS
  def set_outcome(game = %Game{player_one_move: p1_move}) when is_nil(p1_move), do: game
  def set_outcome(game = %Game{player_two_move: p2_move}) when is_nil(p2_move), do: game

  ## DRAWS
  def set_outcome(game = %Game{player_one_move: p1, player_two_move: p2}) when p1 == p2 do
    %{game | outcome: "draw"}
  end

  ## P1 WINS
  def set_outcome(game = %Game{player_one_move: "rock", player_two_move: "scissors"}) do
    %{game | outcome: "player_one"}
  end

  def set_outcome(game = %Game{player_one_move: "scissors", player_two_move: "paper"}) do
    %{game | outcome: "player_one"}
  end

  def set_outcome(game = %Game{player_one_move: "paper", player_two_move: "rock"}) do
    %{game | outcome: "player_one"}
  end

  ## P2 WINS
  def set_outcome(game) do
    %{game | outcome: "player_two"}
  end
end

