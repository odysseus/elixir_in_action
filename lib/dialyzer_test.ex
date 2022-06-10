defmodule Dialyzer.Test do
  @spec add(number, number) :: integer
  def add(a, b) when is_integer(a) and is_integer(b) do
    a + b
  end

  def add(a, b) when is_number(a) and is_number(b) do
    round(a + b)
  end

  @spec poll(integer) :: {:error, {any, atom, String.t}} | {:ok, {any, String.t}}
  def poll(n) do
    case n do
      x when x == 7 -> {:lucky, "Seven"}
      x when rem(n, 2) == 0 -> {:ok, {x, "Success"}}
      x -> {:error, {x, :odd, "Failure"}}
    end
  end

  @spec truesum([boolean]) :: integer
  def truesum([]), do: 0
  def truesum([h | t]) when h, do: 1 + truesum(t)
  def truesum([_ | t]), do: 0 + truesum(t)

  def rlisum([]), do: 0
  def rlisum([h | t]), do: add(h, rlisum(t))

  def main() do
    # IO.puts(rlisum(["dog", "cat", "emu"]))
    # s = truesum([true, false, :dog, "cat", 12])
    # truesum([true, false])
    # {:lucky, str} = poll(7)
    {:ok, {a, b}} = poll(7)
  end
end
