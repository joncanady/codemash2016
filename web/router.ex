defmodule Codemash2016.Router do
  use Codemash2016.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Codemash2016 do
    pipe_through :browser # Use the default browser stack

    get "/", GameController, :index

    get "/start", GameController, :start
    get "/game/:game_code", GameController, :game
    get "/join/:game_code", GameController, :join
  end

  # Other scopes may use custom stacks.
  # scope "/api", Codemash2016 do
  #   pipe_through :api
  # end
end
