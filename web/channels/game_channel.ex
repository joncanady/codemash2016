defmodule Codemash2016.GameChannel do
  use Phoenix.Channel
  alias Codemash2016.Game
  alias Codemash2016.GameBucket

  defp game_for(code) do
    GameBucket.game_for(code)
  end

  def join("games:" <> game_code, _params, socket) do
    {:ok, game_for(game_code), assign(socket, :game_code, game_code)}
  end

  def handle_in("join:" <> slot, %{"name" => name}, socket) do
    game = GameBucket.update(socket.assigns[:game_code],
                             Game.add_player(game_for(socket.assigns[:game_code]),
                                             slot,
                                             name))
    broadcast! socket, "join", game

    {:noreply, socket}
  end
end

