defmodule MapStore do
  use GenServer

  @impl GenServer
  def init(map \\ %{}) do
    # :timer.send_interval(60000, :cache)
    {:ok, map || %{}}
  end

  @impl GenServer
  def handle_cast(msg, state) do
    case msg do
      {:put, key, val} -> {:noreply, Map.put(state, key, val)}
      _ -> {:noreply, state}
    end
  end

  @impl GenServer
  def handle_call(msg, _, state) do
    case msg do
      {:get, key} -> {:reply, Map.get(state, key), state}
      {:inspect} -> {:reply, state, state}
      _ -> {:reply, :invalidmsg, state}
    end
  end

  @impl GenServer
  def handle_info(msg, state) do
    case msg do
      :cache -> IO.puts("Persisting Data")
      _ -> nil
    end
    {:noreply, state}
  end

  def start(map \\ %{}) do
    GenServer.start(MapStore, map, name: __MODULE__)
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def inspect do
    GenServer.call(__MODULE__, {:inspect})
  end

end

# {:ok, pid} = MapStore.start()
# MapStore.put(pid, :name, "Stella")
# IO.puts(MapStore.get(pid, :name))
