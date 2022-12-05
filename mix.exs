defmodule KinoAOC.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_aoc,
      version: "0.1.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoAOC.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.6.1 or ~> 0.7.0"},
      {:req, "~> 0.3"}
    ]
  end
end
