defmodule Plug.CapitalizeQueryParam do
  def init(param) do
    param
  end

  def call(conn, param) do
    query_params =
      Map.put(conn.query_params, "name", titleize(conn.query_params[param]))

    %Plug.Conn{conn | query_params: query_params}
  end

  defp titleize(query_param) when is_binary(query_param) do
    query_param
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.intersperse(" ")
  end

  defp titleize(_), do: "Hello there!"
end
