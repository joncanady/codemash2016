defmodule Codemash2016.GameTest do
  use ExUnit.Case, async: true

  test "generate_game_code returns a five-length String" do
    assert Codemash2016.Game.generate_game_code |> String.length == 5
  end
end
