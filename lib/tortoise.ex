defmodule Tortoise do
  @moduledoc """
  Another message-passing module that simulates slow calls by
  passing an argument (in ms) and sleeping before returning
  """

  def async_call(f, arg, sleepms) do
    long_call = fn fx, argx, sleep ->
      Process.sleep(sleep)
      fx.(argx)
    end

    caller = self()
    spawn(fn ->
      send(caller, long_call.(f, arg, sleepms))
    end)
  end

  def async_return(ret_tuple, sleepms) do
    async_call(fn tup -> tup end, ret_tuple, sleepms)
  end

  def server_loop() do
    receive do
      {:ok, msg} ->
        IO.puts("#{msg}")
        server_loop()
      {:error, _} ->
        IO.puts("Error")
        server_loop()
      {:exit, _} -> :ok
    after
      3000 -> IO.puts("Server timed out")
    end
  end

  def fizzbuzzzap(n) do
    case {rem(n, 3), rem(n, 5), rem(n, 7)} do
      {0, 0, 0} -> {:halt, n, nil}
      {_, 0, 0} -> {:notfound, n, nil}
      {0, _, 0} -> {:error, n, nil}
      {0, 0, _} -> {:ok, n, "FizzBuzz"}
      {_, _, 0} -> {:ok, n, "Zap"}
      {_, 0, _} -> {:ok, n, "Buzz"}
      {0, _, _} -> {:ok, n, "Fizz"}
      _ -> {:pass, n, nil}
    end
  end

  def fbz_server() do
    receive do
      {:exit, _, _} ->
        :ok
      {:halt, n, _} ->
        IO.puts("Halt from #{n}")
        async_return({:exit, nil, nil}, 100)
        fbz_server()
      {:notfound, n, _} ->
        IO.puts("#{n}: Not found")
        fbz_server()
      {:error, n, _} ->
        IO.puts("#{n}: Error")
        fbz_server()
      {:ok, n, str} ->
        IO.puts("#{n}: #{str}")
        fbz_server()
      {:pass, _, _} ->
        fbz_server()
      _ ->
        IO.puts("Unexpected Response")
    after
      10000 -> IO.puts("Server timed out")
    end
  end

end

# Enum.map(1..100, &Tortoise.async_return({:ok, &1}, 2000))
# Tortoise.server_loop()

# fizzbuzz = &Tortoise.fizzbuzzzap(&1)
# Enum.map(1..1000, &Tortoise.async_call(fizzbuzz, &1, 2000))

# Tortoise.fbz_server()
