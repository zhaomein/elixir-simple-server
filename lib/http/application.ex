defmodule Http.Application do
  require Logger
  require Poison

  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port, active: false, packet: :http_bin, reuseaddr: true)
    Logger.info("Accepting connections on port #{port}")

    # {:ok, spawn_link(Http.Application, :accept, [socket])}
    accept(socket)
  end

  def accept(socket) do
    {:ok, req} = :gen_tcp.accept(socket)
    recv = :gen_tcp.recv(req, 0)

    case recv do
        {:ok, info} -> process_request(req, info)
        _ -> Logger.info("Close request")
    end

    accept(socket)
  end

  # Process request
  defp process_request(req, info) do
    spawn(fn -> Router.init(req, info, {}) end)
  end


end