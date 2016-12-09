defmodule RequestCounter do
  use GenServer

  def check_rate(%{remote_ip: ip}, opts) do
    GenServer.call(
      Process.whereis(__MODULE__),
      {:check_rate, ip}
    )
  end

  def init(opts) do
    {:ok, %{}}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  def handle_call({:check_rate, ip}, _, state) do
    bn = div(:erlang.system_time(:milli_seconds), 60000)
    new_state = update_in(state, [bn], fn bucket ->
      Map.update(bucket || %{}, ip, 1, &(&1 + 1))
    end)

    IO.inspect(new_state)

    {:reply, check_count(get_in(new_state, [bn, ip])), new_state}
  end

  def check_count(count) do
    if count > 10 do
      {:fail, count}
    else
      {:ok, "sall good"}
    end
  end
end
