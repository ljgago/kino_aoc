defmodule KinoAOC.MixProject do
  use Mix.Project

  @source_url "https://github.com/ljgago/kino_aoc"
  @version "0.1.7"

  def project do
    [
      # Library
      app: :kino_aoc,
      version: @version,

      # Elixir
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "KinoAOC",
      package: package(),
      description: description(),
      source_url: @source_url,
      docs: docs()
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
      {:req, "~> 0.4"},
      # docs
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "kino_aoc",
      formatters: ["html", "epub"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp description() do
    "A helper for Advent of Code (a smart cell) for Elixir Livebook"
  end

  defp docs() do
    [
      main: "KinoAOC",
      name: "KinoAOC",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/kino_aoc",
      source_url: @source_url,
    ]
  end

end
