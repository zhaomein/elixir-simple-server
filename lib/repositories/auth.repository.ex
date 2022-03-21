defmodule Repository.Auth do
  require Jwt

  def verify_token(token) do
    case Jwt.verify(token) do
      {:ok, payload} ->
      # TODO: query db here
        true
      _ -> { :error, nil}
    end
  end

end