defmodule Handlers.Home do

  @spec index(req:: Request) :: String.t()
  def index(req) do
    Response.html(200, "<h1>Hello this is a chat server</h1>")
  end

end