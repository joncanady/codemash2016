defmodule Codemash2016.GameChannel do
  use Phoenix.Channel

  def join("games:" <> _game_id, _params, socket) do
    {:ok, socket}
  end
end
