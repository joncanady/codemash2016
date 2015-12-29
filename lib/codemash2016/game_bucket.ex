defmodule Codemash2016.GameBucket do
  alias Codemash2016.Game

  ### CLIENT!

  @doc """
  Get the game for `code`. Will initialize a new game if one doesn't exist.
  """
  def game_for(code, bucket \\ __MODULE__) do
    game = get(bucket, code)
    if !game do
      game = %Codemash2016.Game{game_code: code}
      put(bucket, code, game)
    end

    game
  end

  @doc """
  Update the `game` for `code`.
  """
  def update(code, game, bucket \\ __MODULE__) do
    if Codemash2016.Game.all_players_joined?(game) do
      game = %{game | started: true}
    end

    game
    |> Game.set_started_flag
    |> Game.set_outcome

    put(bucket, code, game)

    game
  end

  ### AGENT!

  @doc """
  Starts a new bucket of games.
  """
  def start_link(_opts) do
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
