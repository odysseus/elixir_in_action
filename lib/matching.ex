# An assortment of examples for pattern matching, recursion,
# guard statements, and other nice functional patterns.

defmodule Order do
  @current_year :calendar.local_time |> elem(0) |> elem(0)

  def process(order = %{priority: :high}) do
    IO.puts("High priority account: #{order[:accountno]}")
  end

  def process(order = %{priority: _}) do
    IO.puts("Not high priority account: #{order[:accountno]}")
  end

  def process(_any) do
    IO.puts("Unknown order priority")
  end

  def order_year(%{date: {year, month, day}}) when year == @current_year do
    IO.puts("Order from this year on #{month}/#{day}")
  end

  def order_year(%{date: {year, month, day}}) do
    IO.puts("Order from #{year}/#{month}/#{day}")
  end

  def during_lunch?({{_, _, _}, {hour, _, _}}) when hour < 12 do
    {false, :before_lunch}
  end

  def during_lunch?({{_, _, _}, {hour, _, _}}) when hour >= 13 do
    {false, :after_lunch}
  end

  def during_lunch?({{_, _, _}, {hour, _, _}}) when hour == 12 do
    {true, :during_lunch}
  end

end

defmodule ListRecur do
  def sum([]), do: 0
  def sum([h | t]), do: h + sum(t)

  def tailsum([], acc), do: acc
  def tailsum([h | t], acc) do
    tailsum(t, acc + h)
  end
  def tailsum([h | t]), do: tailsum([h | t], 0)
end

defmodule Recur do
  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n), do: fibonacci(n-1) + fibonacci(n-2)

  def fibotail(0), do: 0
  def fibotail(1), do: 1
  def fibotail(n), do: fibotail(n, 1, 0, 1)
  def fibotail(n, i, _, b) when i == n, do: b
  def fibotail(n, i, a, b) when i < n, do: fibotail(n, i+1, b, a+b)

  def primesinrange(a, b) when a > b, do: []
  def primesinrange(a, b) when a <= b do
    if Number.prime?(a) do
      [a | primesinrange(a+1, b)]
    else
      primesinrange(a+1, b)
    end
  end

  def tailprimesinrange(a, b) when a > 0 and b >= a do
    tailprimesinrange(a, b, [])
  end
  def tailprimesinrange(a, b, lst) when a > b, do: lst
  def tailprimesinrange(a, b, lst) when a > 0 and a <= b do
    if Number.prime?(a) do
      tailprimesinrange(a+1, b, [a | lst])
    else
      tailprimesinrange(a+1, b, lst)
    end
  end
end

defmodule Number do
  def prime?(n) when not is_integer(n) or n < 0, do: :error
  def prime?(n) when n <= 0, do: false
  def prime?(n) when n in [1, 2, 3, 5, 7], do: true
  def prime?(n) when rem(n, 2) == 0, do: false
  def prime?(n) when rem(n, 3) == 0, do: false
  def prime?(n) when rem(n, 5) == 0, do: false
  def prime?(n) do
    upto = trunc(:math.sqrt(n))
    prime?(n, 7, upto)
  end

  def prime?(n, i, upto) when i <= upto do
    if rem(n, i) == 0 do
      false
    else
      prime?(n, i+2, upto)
    end
  end

  def prime?(_n, i, upto) when i > upto, do: true
  def prime?(_n, _i, _upto), do: :error

end

# ordera = %{accountno: 1234, date: {2022, 3, 18}, priority: :high}
# orderb = %{accountno: 3456, date: {2022, 3, 14}, priority: :low}
# orderc = %{accountno: 1234, priority: :high, date: {2021, 03, 18}}

# possible_prime? =
# fn
#   n when not is_integer(n) -> :error
#   n when n == 0 -> false
#   n when n == 1 -> true
#   n when n == 2 -> true
#   n when rem(n, 2) == 0 -> false
#   n when rem(n, 3) == 0 -> false
#   n when rem(n, 5) == 0 -> false
#   _ -> true
# end
#
# n = 60_419_650_387_267
# j = 914_148_152_112_161
#
# IO.puts(possible_prime?.(n))
# IO.puts(Number.prime?(n))
#
# IO.puts(possible_prime?.(j))
# IO.puts(Number.prime?(j))
#
# with {{year, _, _}, _} = :calendar.local_time do
#   IO.puts(year)
# end

# lst = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# IO.puts("Recursive sum: #{ListRecur.sum(lst)}")
# IO.puts("Tail Recursive sum: #{ListRecur.tailsum(lst)}")
#
# n = 25
# IO.puts("The #{n}th Fibonacci number: #{Recur.fibonacci(n)}")
# IO.puts("The #{n}th Fibonacci number (tail version): #{Recur.fibotail(n)}")
#
# n = 1000
# IO.puts("The #{n}th Fibonacci number (tail version): #{Recur.fibotail(n)}")

# {a, b} = {1, 1_000_000}
# IO.inspect(Recur.tailprimesinrange(a, b))
# IO.inspect(Recur.primesinrange(a, b))

# {a, b} = {1, 1_000_000}
#
# primes = Enum.filter(a..b, fn x -> Number.prime?(x) end)
# IO.inspect(primes)
#
# nprimes = Enum.reduce(primes, 0, fn _elem, acc -> acc + 1 end)
# IO.puts(nprimes)
#
# sumeven = Enum.reduce(
#             1..1_000_000,
#             0,
#             fn
#               n, acc when rem(n, 2) == 0 -> acc + n
#               _, acc -> acc
#             end
#           )
#
# evensum = Enum.reduce(
#             1..1_000_000,
#             0,
#             fn n, acc -> if rem(n, 2) == 0, do: acc + n, else: acc end
#           )
#
# add_even = fn
#   n, acc when rem(n, 2) == 0 -> acc + n
#   _, acc -> acc
# end
#
# IO.puts(sumeven)
# IO.puts(evensum)
#
# times_table =
# 	for x <- 1..9, y <- 1..9,
# 	y > x,
# 	into: %{} do
# 		{{x, y}, x * y}
# 	end
#
# airport_codes =
#   for x <- 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
#   y <- 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
#   z <- 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
#   x != y or y != z do
#     [x, y, z]
#   end

# IO.inspect(airport_codes)
# IO.puts(length(airport_codes))

# preds = [3, 4, 4, 8, 6, 4]
# vals  = [2, 3, 3, 4, 5, 2]

# sse =
#   preds
#   |> Stream.zip(vals)
#   |> Stream.map(fn {pred, val} -> (pred - val) ** 2 end)
#   |> Enum.reduce(0, fn n, acc -> n + acc end)

# IO.inspect(sse)
