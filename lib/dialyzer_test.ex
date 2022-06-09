defmodule Dialyzer.Test do
  @spec add(number, number) :: integer
  def add(a, b) when is_integer(a) and is_integer(b) do
    a + b
  end

  def add(a, b) when is_number(a) and is_number(b) do
    round(a + b)
  end

  @spec poll(integer) :: {:ok, {any, String.t}} | {:error, {any, any, String.T}}
  def poll(n) do
    case n do
      x when rem(n, 2) == 0 -> {:ok, {x, "Success"}}
      x -> {:error, {x, :odd, "Failure"}}
    end
  end

  def main() do
    {:ok, {a, b, c}} = poll(4)
  end
end
