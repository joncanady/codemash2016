defmodule Codemash2016.GameBucketTest do
  use ExUnit.Case, async: true
  alias Codemash2016.GameBucket
  alias Codemash2016.Game

  setup do
    {:ok, bucket} = GameBucket.start_link name: {:global, __MODULE__}
    {:ok, bucket: bucket}
  end

  test "game_for returns a new game if one isn't present", %{bucket: bucket} do
    assert GameBucket.game_for('UNKNOWN_CODE', bucket) == %Game{game_code: 'UNKNOWN_CODE'}
  end

  test "game_for returns an existing game if one is in the bucket", %{bucket: bucket} do
    game = %Game{game_code: 'CODE', player_one_name: 'Bob'}
    :ok = GameBucket.put(bucket, 'CODE', game)
    assert GameBucket.game_for('CODE', bucket) == game
  end

  test "returns nil for game codes that aren't present", %{bucket: bucket} do
    assert GameBucket.get(bucket, 'GAMECODE') == nil
  end

  test "returns a %Game for codes that are present", %{bucket: bucket} do
    game = %Game{}
    GameBucket.put(bucket, 'GAMECODE', game)
    assert GameBucket.get(bucket, 'GAMECODE') == game
  end
end
