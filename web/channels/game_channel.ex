defmodule Codemash2016.GameChannel do
  use Phoenix.Channel

  alias Codemash2016.Game
  alias Codemash2016.GameBucket

  defp game_for(code) do
    GameBucket.game_for(code)
  end

  defp update_game(game, code) do
    GameBucket.update(code, game)
    game
  end

  def join("games:" <> game_code, _params, socket) do
    {:ok, game_for(game_code), assign(socket, :game_code, game_code)}
  end

  def handle_in("join:" <> slot, %{"name" => name}, socket) do
    code = socket.assigns[:game_code]
    game = code
    |> game_for
    |> Game.add_player(slot, name)
    |> Game.set_started_flag
    |> update_game(code)

    broadcast! socket, "update", game

    {:noreply, socket}
  end

  def handle_in("shoot", %{"player" => player, "choice" => choice}, socket) do
    code = socket.assigns[:game_code]
    game = code
    |> game_for
    |> Game.shoot(player, choice)
    |> Game.set_outcome
    |> update_game(code)

    broadcast! socket, "update", game

    {:noreply, socket}
  end
end

