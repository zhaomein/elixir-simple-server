defmodule Middlewares do
  require String;

  @spec auth(req:: Request):: Atom.t()
  def auth(req) do
    bearer_token = req.headers["authorization"]
    case bearer_token do
      bearer_token when is_binary(bearer_token) ->
        [ _, token ] = String.split(bearer_token, " ")

        { status, user } = Repository.Auth.verify_token(String.trim(token))
        status == :ok
      _ -> false
    end
  end

end