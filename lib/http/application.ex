defmodule Http.Application do
  require Logger

  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port, active: false, packet: :http_bin, reuseaddr: true)
    Logger.info("Accepting connections on port #{port}")

    {:ok, spawn_link(Http.Application, :accept, [socket])}
  end

  def accept(socket) do
    {:ok, req} = :gen_tcp.accept(socket)
    {status, info} = :gen_tcp.recv(req, 0)

    if status != :ok do
      false
    end

    {_, method, {_, path}, _} = info

    spawn(fn ->
      body = "Hello world! The time is #{Time.to_string(Time.utc_now())}"

      response = """
      HTTP/1.1 200\r
      Content-Type: text/html\r
      Content-Length: #{byte_size(body)}\r

      #{body}
      """

      send_response(req, response)
    end)

    accept(socket)
  end

  def send_response(req, response) do
    :gen_tcp.send(req, response)
    :gen_tcp.close(req)
  end
end