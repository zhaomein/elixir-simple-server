defmodule Handlers.Auth do
  def register(req) do
    Response.json(200, %{status: true})
  end

  def login(req) do
    Response.json(200, %{status: true})
  end
end