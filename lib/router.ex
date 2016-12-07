defmodule Router do
  use Plug.Router

  plug :fetch_query_params
  plug Plug.CapitalizeQueryParam, "name"
  plug Plug.Throttle#, limit: 6, scale: 60_000
  plug :match
  plug :dispatch

  get "/hello" do
    IO.inspect conn
    send_resp(conn, 200, conn.query_params["name"])
  end

  match _ do
    IO.inspect conn
    send_resp(conn, 404, "where you snooping?!")
  end
end
