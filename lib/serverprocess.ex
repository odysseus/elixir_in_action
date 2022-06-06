defmodule ServerProcess do
  @moduledoc """
  A stateful server process that does not use GenServer,
  rather it implements a GenServer-like construct itself.
  """
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} =
          callback_module.handle_call(
            request,
            current_state
          )
        send(caller, {:response, response})
        loop(callback_module, new_state)
      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )
        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

end

defmodule KVStore do
  def init do
    %{}
  end

  def start do
    ServerProcess.start(KVStore)
  end

  def put(pid, key, value) do
    ServerProcess.call(pid, {:put, key, value})
  end

  def put!(pid, key, value) do
    ServerProcess.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    ServerProcess.call(pid, {:get, key})
  end

  def handle_call({:put, key, value}, state) do
    {:ok, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end

  def handle_call(_, state) do
    {:errunknown, state}
  end

  def handle_cast(msg, state) do
    case msg do
      {:put, key, value} -> Map.put(state, key, value)
      _ -> state
    end
  end

end
