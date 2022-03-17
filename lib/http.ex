defmodule Http do
  def start(_type, _args) do
    Http.Application.start(3000)
  end
end
