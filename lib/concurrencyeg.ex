defmodule Tortoise do

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

  def fake_return(ret_tuple) do
    ret_tuple
  end

  def async_return(ret_tuple, sleepms) do
    async_call(&fake_return/1, ret_tuple, sleepms)
  end

  def process_loop() do
    receive do
      {:ok, _spid, msg} ->
        IO.puts("#{msg}")
        process_loop()
      {:error, _spid, _} ->
        IO.puts("Error")
        process_loop()
      {:exit, _, _} -> :ok
    after
      3000 -> IO.puts("Processing timed out with no exit")
    end
  end

  def fizzbuzzzap(n) do
    case {rem(n, 3), rem(n, 5), rem(n, 7)} do
      {0, 0, 0} -> :halt
      {_, 0, 0} -> :notfound
      {0, _, 0} -> :error
      {0, 0, _} -> :fizzbuzz
      {_, _, 0} -> :zap
      {_, 0, _} -> :buzz
      {0, _, _} -> :fizz
      _ -> n
    end
  end

end

Tortoise.async_return({:ok, "Hello, world!"}, 2000)

receive do
  {_, str} -> IO.puts(str)
  _ -> IO.puts("Unexpected Response")
after
  3000 -> IO.puts("Timeout")
end
