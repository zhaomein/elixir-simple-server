defmodule Jwt do

#  @secret Application.fetch_env!(:chat_server, :JWT_SCRET)

  # Create JWT token
  @spec create(payload:: Map):: String.t()
  def create(m_payload) do

    {_, headers} = Poison.encode(%{alg: "HS256", typ: "JWT"})
    {_, payload} = Poison.encode(m_payload)

    headers_payload = "#{Base.url_encode64(headers, padding: false)}.#{Base.url_encode64(payload, padding: false)}"

    signature = :crypto.mac(:hmac, :sha256, headers_payload, "GM8pxBYJqsN4YBjSmxCUAkHTGquWzxGWZRuwuHmV")

    "#{headers_payload}.#{Base.url_encode64(signature, padding: false)}"
  end

  def verify(token) do

  end

end