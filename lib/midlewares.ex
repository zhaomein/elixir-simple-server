defmodule Middlewares do

  @spec auth(req:: Request):: Atom.t()
  def auth(req) do
    true
  end
end