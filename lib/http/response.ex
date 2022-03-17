
defmodule Response do
  @types %{json: "application/json", text_html: "text/html"}

  # Send response
  defp send_response(req, content_type, status_code, body) when is_integer(status_code) do
    response = """
      HTTP/1.1 #{status_code}\r
      Content-Type: #{content_type}\r
      Content-Length: #{byte_size(body)}\r

      #{body}
    """
    :gen_tcp.send(req, response)
    :gen_tcp.close(req)
  end

  # Send json response
  def json(req, status_code, body) do
    json_data = Poison.encode!(body)
    send_response(req, @types[:json], status_code, json_data)
  end

  # Send html response
  def html(req, status_code, body) do
    send_response(req, @types[:text_html], status_code , body)
  end

end
