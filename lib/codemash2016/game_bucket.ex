defmodule Codemash2016.GameBucket do
  @doc """
  Starts a new bucket of games.
  """
  def start_link do
    Agent.start_link fn -> HashDict.new end, name: __MODULE__
  end

  @doc """
  Get a game from `bucket` by `code`
  """
  def get(bucket, code) do
    Agent.get(bucket, &HashDict.get(&1, code))
  end

  @doc """
  Put a `game` into `bucket` under `code`
  """
  def put(bucket, code, game) do
    Agent.update(bucket, &HashDict.put(&1, code, game))
  end
end
