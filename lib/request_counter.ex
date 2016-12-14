defmodule RequestCounter do
  use GenServer

  def check_rate(%{remote_ip: ip}, opts) do
    GenServer.call(
      Process.whereis(__MODULE__),
      {:check_rate, ip, opts}
    )
  end

  def init(opts) do
    {:ok, %{}}
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  def handle_call({:check_rate, ip, opts}, _, state) do
    timeout = Keyword.get opts, :timeout, 60000
    bucket = div(:erlang.system_time(:milli_seconds), timeout)

    new_state = update_in(state, [bucket], fn bucket ->
      Map.update(bucket || %{}, ip, 1, &(&1 + 1))
    end)

    limit = Keyword.get opts, :limit, 10

    {:reply, check_count(get_in(new_state, [bucket, ip]), limit), new_state}
  end

  def check_count(count, limit) do
    if count > limit do
      {:fail, count}
    else
      {:ok, "sall good"}
    end
  end
end
