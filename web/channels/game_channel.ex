defmodule Codemash2016.GameChannel do
  use Phoenix.Channel

  def join("games:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("games:" <> _game_id, _params, _socket) do
    {:error, %{reason: "Nope."}}
  end
end
