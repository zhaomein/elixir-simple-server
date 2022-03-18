defmodule Request do
  defstruct method: "GET", path: "/", query: %{}, headers: %{}
end

defmodule Router do
  require Logger

  import String, only: [split: 2, trim: 1, to_atom: 1]

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
      {method, path, _} = r
      method == req.method and String.match?(req.path, path)
    end)
    IO.puts(route)
    Response.html 200, "<h1>Adadasd</h1>"
  end

  # Default value of headers parameter is a empty List
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