require Handlers.Home
require Handlers.Auth
require Middlewares

defmodule Routes do
  def all do
    [
      {:GET, "/", &Handlers.Home.index/1},
      # Auth
      {:GET, "/auth/register", &Handlers.Auth.register/1},
      {:GET, "/auth/login", &Handlers.Auth.login/1},
      # Chat
      {:GET, "/chat", &Handlers.Chat.messages/1, [&Middlewares.auth/1]},
    ]
  end
end
