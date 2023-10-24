
defmodule Response do
  @messages %{
    200 => "OK",
    404 => "Not Found",
    500 => "Internal Error"
  }

  # Send json response
  def json(code, body) do
    body = Poison.encode!(body)
    response("application/json", code, body)
  end

  # Send html response
  def html(code, body) do
    response("text/html", code , body)
  end

  def forbidden() do
    Response.html 403, "<h1>403 Forbidden!</h1>"
  end

  # Common response
  defp response(type, code, body) do
    code = code || 500
    """
    HTTP/1.1 #{code} #{message(code)}}
    Content-Type: #{type}
    Content-Length: #{byte_size(body)}

    #{body}
    """
  end

  defp message(code), do: @messages[code] || "Unknown"
end
