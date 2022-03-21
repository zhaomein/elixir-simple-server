defmodule Request do
  defstruct method: "GET", path: "/", query: %{}, headers: %{}
end

defmodule Router do
  require Logger
  require Regex
  import String, only: [split: 2, trim: 1, to_atom: 1, trim: 2]

  defstruct method: "GET", path: "/", controller: nil

  def map(socket) do
    # Read and remove first line of headers
    # ** First line of headers contains method, part,
    # ** query params and HTTP version
    {:ok, info} = :gen_tcp.recv(socket, 0)

    # Pass return value as the first parameter of next function
    socket
      |> _read(info)
      |> _process
  end

  # Read request
  @spec _read(socket:: Port, info:: String.t()):: Request
  defp _read(socket, info) do
    [method, path_query, _] = split(info, " ")

    headers = _read_headers(socket)
    {path, query} = _read_query(path_query)

    %Request{
      method: to_atom(method),
      path: path,
      query: query,
      headers: headers
    }
  end

  # Process request
  @spec _process(req:: Request):: String.t()
  defp _process(req) do
    route = Enum.find(Routes.all(), nil, fn(r) ->
      # TODO: match path with regex
      {method, path} = case r do
        {method, path, _} -> {method, path}
        {method, path, _, _} -> {method, path}
      end

      {_, regex } = Regex.compile("^#{path}$")

      method == req.method and Regex.match?(regex, "/#{trim(req.path, "/")}")
    end)

    case route do
      {_, _, handler} -> call_handler(handler, nil, req)
      {_, _, handler, middleware} -> call_handler(handler, middleware, req)
      nil -> Response.html 404, "<h1>Path: #{req.method} #{req.path} not found in routes!</h1>"
    end
  end

  defp call_handler(handler, middleware, req) do
    m = middleware || fn (_) -> true end
    case m.(req) do
      true -> handler.(req)
      _ -> Response.html 403, "<h1>403 Forbidden!</h1>"
    end
  end

  # Default value of headers parameter is a empty List
  @spec _read_headers(socket::Port, headers:: Map):: Map
  defp _read_headers(socket, headers \\ %{}) do
    # Headers is end with a empty line
    # End of loop
    case :gen_tcp.recv(socket, 0) do
      {:error, _} -> %{}
      # When has a break line
      {:ok, line} when byte_size(line) <= 2 -> %{}
      {:ok, line} ->
        # Split raw line to List string with key and value
        [key | value_arr] = split(line, ":")
        value = Enum.join(value_arr, ":")

        # Do a looping until read to end of headers and return List of headers
        Map.merge(%{trim(key) => trim(value)}, _read_headers(socket, headers))
    end
  end

  # Parse query parameters
  defp _read_query (path_query) do
    case split(path_query, "?") do
      # has query parameters
      [path | query_string] when query_string != [] ->
        part_list = split hd(query_string), "&"

        query = Enum.reduce part_list, %{}, fn (part, acc) ->
          [key, value] = split(part, "=")
          Map.put(acc, key, value)
        end

        {path, query}

      # no query parameters
      [path] ->
        {path, %{}}
    end
  end
end