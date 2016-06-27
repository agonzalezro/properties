defmodule Properties.Mixfile do
  use Mix.Project

  def project do
    [app: :properties,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: [main_module: Properties],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion, :exconstructor]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 2.0"},
      {:httpotion, "~> 2.2.0"},
      {:csvlixir, "~> 2.0.3"},
      {:exconstructor, "~> 1.0.2"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:mock, "~> 0.1.1", only: :test}
    ]
  end
end
