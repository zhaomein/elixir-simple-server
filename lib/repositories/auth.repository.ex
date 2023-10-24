defmodule Repository.Auth do
  require Jwt

  def verify_token(token) do
    case Jwt.decode(token) do
      {:ok, data} ->
        IO.puts(data)
        { :ok, nil }
      {:expired, nil} -> { :expired, nil}
      _ -> { :error, nil}
    end
  end

end