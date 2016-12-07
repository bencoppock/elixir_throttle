defmodule Plug.Throttle do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    case RequestCounter.check_rate(conn, opts) do
      {:ok, _count}  -> conn
      {:fail, count} -> too_many(conn, count)
    end
  end

  defp too_many(conn, count) do
    conn
    |> send_resp(429, "#{count} is too many requests!")
    |> halt
  end
end
