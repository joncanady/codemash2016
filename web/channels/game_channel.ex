defmodule Codemash2016.GameChannel do
  use Phoenix.Channel
  require Logger

  def join("games:" <> _game_id, _params, socket) do
    Logger.debug "JOIN #{_game_id}"
    {:ok, socket}
  end

  def handle_in("join:" <> slot, %{"name" => name}, socket) do
    Logger.debug "#{slot}: #{name} has entered the game."
    broadcast! socket, "join", %{player: slot, name: name}
    {:noreply, socket}
  end

  def handle_in("join", %{"player_two" => %{"name" => name}}, socket) do
    Logger.debug "Player 2 Join: #{name}"
    broadcast! socket, "join", %{"player_two" => name}
    {:noreply, socket}
  end

  def handle_in(event, msg, socket) do
    Logger.debug "Other event." 
    broadcast! socket, event, msg
    {:noreply, socket}
  end
end

