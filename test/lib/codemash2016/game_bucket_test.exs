defmodule Codemash2016.GameBucketTest do
  use ExUnit.Case, async: true
  alias Codemash2016.GameBucket
  alias Codemash2016.Game

  setup do
    {:ok, bucket} = GameBucket.start_link
    {:ok, bucket: bucket}
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
