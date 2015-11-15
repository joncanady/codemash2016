defmodule Codemash2016.PageController do
  use Codemash2016.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
