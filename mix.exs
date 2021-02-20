defmodule Paapi5.MixProject do
  use Mix.Project

  @source_url "https://github.com/dallagi/paapi5"
  @version "0.1.1"

  def project do
    [
      app: :paapi5,
      description: "A minimalistic library for the Amazon Product Advertising Api version 5 (PAAPI5).",
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        links: %{"GitHub" => @source_url},
        licenses: ["MIT"]
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "LICENSE"],
        source_ref: "v#{@version}",
        source_url: @source_url
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:crypto, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8", only: [:dev, :test]}
    ]
  end
end
