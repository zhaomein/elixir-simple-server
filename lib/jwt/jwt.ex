defmodule Jwt do

  @secret Application.get_env(:chat_server, :JWT_SECRET)
  @exp Application.get_env(:chat_server, :JWT_EXP, 60)
  @alg "HS256"

  # Create JWT token
  @spec encode(payload:: Map):: String.t()
  def encode(data) do

    m_payload = Map.put(data, "exp", :os.system_time(:seconds) + @exp)
    {_, headers} = Poison.encode(%{alg: "HS256", typ: "JWT"})
    {_, payload} = Poison.encode(m_payload)

    h = Base.url_encode64(headers, padding: false)
    p = Base.url_encode64(payload, padding: false)

    signature = :crypto.mac(:hmac, :sha256, "#{h}.#{p}", @secret)
    s = Base.url_encode64(signature, padding: false)

    "#{h}.#{p}.#{s}"
  end

  # Decode JWT token
  @spec decode(token:: String):: ({:error, nil} | {:expired, nil} | {:ok, Map})
  def decode(token) do
    case String.split(token, ".") do
      [h, p, s] ->
        try do
          { :ok, headers } = Poison.decode(Base.url_decode64(h, padding: false) |> elem(1))
          { :ok, payload } = Poison.decode(Base.url_decode64(p, padding: false) |> elem(1))
          signature = Base.url_decode64(s, padding: false) |> elem(1)

          # Check algorithm
          if headers["alg"] != @alg do
            throw(:invalid_alg)
          end

          # Check signature
          server_s = :crypto.mac(:hmac, :sha256, "#{h}.#{p}", @secret)
          if server_s != signature do
            throw(:invalid_signature)
          end

          # Check expire time
          if :os.system_time(:seconds) > (payload["exp"] || 0) do
            throw(:expired)
          end

          { :ok, payload }

        catch
          :invalid_alg -> {:error, nil}
          :invalid_signature -> {:error, nil}
          :expired -> {:expired, nil}

        rescue
          RuntimeError -> {:error, nil}
          ArgumentError -> {:error, nil}
        end
      _ -> {:error, nil}
    end
  end

end