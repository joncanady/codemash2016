defmodule Codemash2016.GameTest do
  use ExUnit.Case, async: true
  alias Codemash2016.Game

  test "generate_game_code returns a five-length String" do
    assert Game.generate_game_code |> String.length == 5
  end

  test "a game is waiting for players if either of the players are unnamed" do
    game_missing_p1 = %Game{game_code: 'CODE',
                            player_one: {nil, nil},
                            player_two: {'Bob', nil}}
    game_missing_p2 = %Game{game_code: 'CODE',
                            player_one: {'Alice', nil},
                            player_two: {nil, nil}}

    assert Game.waiting_for_players?(game_missing_p1)
    assert Game.waiting_for_players?(game_missing_p2)
  end

  test "a game is not waiting for players if both players are named" do
    started_game = %Game{game_code: 'CODE',
                         player_one: {'Alice', nil},
                         player_two: {'Bob', nil}}

    refute Game.waiting_for_players?(started_game)
  end
end
