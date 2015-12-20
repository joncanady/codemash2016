defmodule Codemash2016.LayoutView do
  use Codemash2016.Web, :view

  @doc """
  Get the current controller name as a String. Ex: Game for GameController.
  """
  def current_controller(conn) do
    [_ | name] = Regex.run(~r/Elixir.Codemash2016.(.+)Controller/,
                           Atom.to_string(
                             Phoenix.Controller.controller_module(conn)))

    name
  end
end

