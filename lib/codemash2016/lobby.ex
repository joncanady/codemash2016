defmodule Codemash2016.Lobby do
  use GenServer

  ### DAT PUBLIC API

  @doc """
  Start the lobby server.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, HashDict.new}
  end

  ### SERVER CALLBACKS

  def handle_call({ :lookup, name }, _from, names) do
    {:reply, HashDict.fetch(names, name), names}
  end

  def handle_cast({:create, name}, name, names) do
    if HashDict.has_key(names, name) do
      {:noreply, names}
    else
      # TODO: Use a key/value server somehow, get a map of "I have this
      # connection, and I have this name. Reject duplicates?"
    end
  end
end
