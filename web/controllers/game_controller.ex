defmodule Codemash2016.GameController do
  use Codemash2016.Web, :controller
  import Codemash2016.Game

  def index(conn, _params) do
    render conn, "index.html"
  end

  def start(conn, _params) do
    game_code = generate_game_code
    render conn, "start.html", game_code: game_code
  end

  def join(conn, _params) do
    render conn, "join.html"
  end
end
