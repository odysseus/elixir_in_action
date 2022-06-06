defmodule StateServer do
  @moduledoc """
  An experiment with stateful servers before I was introduced
  to basically every single stateful server pattern used in
  Elixir. Implements a stack.
  """

  def new() do
    spawn(&serve/0)
  end

  def serve(lst \\ []) do
    receive do
      {caller, :push, item} ->
        send(caller, {:push, item})
        serve([item | lst])
      {caller, :pop} ->
        [head | tail] = lst
        send(caller, {:pop, head})
        serve(tail)
      {caller, :inspect} ->
        send(caller, {:inspect, lst})
        serve(lst)
      {caller, :halt} ->
        send(caller, :ok)
      _ ->
        serve(lst)
    end
  end

end

# Example usage

# pid = StateServer.new()

# send(pid, {self(), :push, 1})
# send(pid, {self(), :push, 2})
# send(pid, {self(), :push, 3})
# send(pid, {self(), :inspect})
# send(pid, {self(), :pop})
# send(pid, {self(), :pop})
# send(pid, {self(), :inspect})

# for _ <- 1..8 do
#   receive do
#     msg -> IO.inspect(msg)
#   after
#     2000 -> System.halt()
#   end
# end
