require Handlers.Home

defmodule Routes do
  def all do
    [
      {:GET, "/", &Handlers.Home.index/1}
    ]
  end
end