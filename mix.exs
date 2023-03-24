defmodule KinoAOC.MixProject do
  use Mix.Project

  @source_url "https://github.com/ljgago/kino_aoc"

  def project do
    [
      # Library
      app: :kino_aoc,
      version: "0.1.3",

      # Elixir
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "KinoAOC",
      package: package(),
      description: description(),
      source_url: @source_url
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
      {:kino, "~> 0.9"},
      {:req, "~> 0.3"},
      # docs
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "kino_aoc",
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp description() do
    "A helper for Advent of Code (a smart cell) for Elixir Livebook"
  end
end
