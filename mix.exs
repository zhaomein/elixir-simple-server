defmodule ChatServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :chat_server,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [],
      mod: {Http, []},
      extra_applications: [:logger, :poison, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 5.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:skn_bot, git: "https://github.com/skygroup2/skn_bot.git", branch: "main"},
      {:skn_lib, git: "https://github.com/skygroup2/skn_lib.git", branch: "main", override: true},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
