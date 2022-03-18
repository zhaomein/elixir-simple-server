defmodule Http do
  require Logger
  require Poison

  @port 3000

  # The main function where the mix application run on top
  def start(_type, _args) do
    # Listen a TCP connection with given port
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: :line, active: false])
    Logger.info("Accepting connections on port #{@port}")

#     {:ok, spawn_link(Http, :accept, [socket])}
    accept(socket)
  end

  # Accept socket
  def accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    # Map request to controller
    spawn(fn ->
      res = Router.map(client)
      :gen_tcp.send(client, res)
      :gen_tcp.close(client)
    end)

    accept(socket)
  end
end
