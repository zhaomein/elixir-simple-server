defmodule Handlers.Home do
  require Jwt

  @spec index(req:: Request) :: String.t()
  def index(req) do
#    jwt = Jwt.encode(%{hello: "Hello"})
#    jwt = Jwt.decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJoZWxsbyI6IkhlbGxvIn0.UlhfcDNkOvnWISENge3_mP6ULfD-skEWPfgD4dr1eX0")
#    IO.puts(jwt)
    Response.html(200, "<h1>Hello this is a chat server</h1>")
  end

end