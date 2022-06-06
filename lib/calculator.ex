defmodule Calculator do
  @moduledoc """
  Implements a basic calculator that runs in its own process.
  Does not use GenServer, demonstrates basic message passing.
  """

  @doc """
  Spawns a calculator process and starts the serve loop
  """
  def new() do
    spawn(&serve/0)
  end

  # Infinite loop to serve requests. Stores state in the
  # form of the current running calculation.
  defp serve(current_value \\ 0) do
    new_value = receive do
      {:value, caller} ->
        send(caller, {:value, current_value})
        current_value
      {:round, caller} ->
        send(caller, {:rounded, round(current_value)})
        current_value
      {:trunc, caller} ->
        send(caller, {:trunc, trunc(current_value)})
        current_value

      {:add, value} -> current_value + value
      {:sub, value} -> current_value - value
      {:mul, value} -> current_value * value
      {:div, value} -> current_value / value
      {:exp, value} -> current_value ** value
      {:reset} -> 0

      invalid_request ->
        IO.puts("Unknown Request: #{inspect invalid_request}")
        current_value
    end

    serve(new_value)
  end


  # --- Math Functions ---

  def add(pid, n), do: send(pid, {:add, n})
  def sub(pid, n), do: send(pid, {:sub, n})
  def mul(pid, n), do: send(pid, {:mul, n})
  def div(pid, n), do: send(pid, {:div, n})
  def exp(pid, n), do: send(pid, {:exp, n})
  def reset(pid), do: send(pid, {:reset})

  # --- Return Functions ---

  defp result(pid, type) when type in [:value, :round, :trunc] do
    send(pid, {type, self()})
    receive do
      {^type, val} -> val
    after
      3000 -> nil
    end
  end

  def get_value(pid), do: result(pid, :value)
  def get_round(pid), do: result(pid, :round)
  def get_trunc(pid), do: result(pid, :trunc)

end

# Example Usage

# calc = Calculator.new()
# send(calc, {:add, 3})
# send(calc, {:mul, 2})
# send(calc, {:exp, 2})
# send(calc, {:div, 2})
# send(calc, {:sub, 1})
# send(calc, {:value, self()})

# value = receive do
#   {:value, value} -> value
# end

# IO.puts(value)

# Example using the interface methods (AKA: The right way)

# pid = Calculator.new()
# Calculator.add(pid, 3)
# Calculator.mul(pid, 2)
# Calculator.exp(pid, 2)
# Calculator.div(pid, 2)
# Calculator.sub(pid, 1)
# IO.puts(Calculator.get_value(pid))
