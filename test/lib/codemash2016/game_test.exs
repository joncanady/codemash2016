defmodule Codemash2016.GameTest do
  use ExUnit.Case, async: true
  alias Codemash2016.Game

  test "generate_game_code returns a five-length String" do
    assert Game.generate_game_code |> String.length == 5
  end

  test "a game is waiting for players if either of the players are unnamed" do
    game_missing_p1 = %Game{game_code: 'CODE',
                            player_two_name: 'Bob'}
    game_missing_p2 = %Game{game_code: 'CODE2',
                            player_one_name: 'Alice'}

    assert Game.waiting_for_players?(game_missing_p1)
    assert Game.waiting_for_players?(game_missing_p2)
  end

  test "a game is not waiting for players if both players are named" do
    started_game = %Game{game_code: 'CODE',
                         player_one_name: 'Alice',
                         player_two_name: 'Bob'}

    refute Game.waiting_for_players?(started_game)
  end

  test "winning games" do
    outcomes = [
      {"rock", "paper", "player_two"},
      {"rock", "scissors", "player_one"},
      {"rock", "rock", "draw"},
      {"paper", "rock", "player_one"},
      {"paper", "scissors", "player_two"},
      {"paper", "paper", "draw"},
      {"scissors", "scissors", "draw"},
      {"scissors", "paper", "player_one"},
      {"scissors", "rock", "player_two"},
    ]

    Enum.each(outcomes, fn {p1_move, p2_move, outcome} ->
      game = %Game{player_one_move: p1_move, player_two_move: p2_move}
      assert Game.set_outcome(game).outcome == outcome
      end)
  end
end
