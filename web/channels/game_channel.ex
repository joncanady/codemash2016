defmodule Codemash2016.GameChannel do
  use Phoenix.Channel

  def join("games:" <> _game_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("join", %{"player_two" => name}, socket) do
    broadcast! socket, "join", %{"player_two" => name}
    {:noreply, socket}
  end

  def handle_in(event, msg, socket) do
    broadcast! socket, event, msg
    {:noreply, socket}
  end
end

