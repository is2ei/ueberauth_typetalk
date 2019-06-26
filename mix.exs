defmodule UeberauthTypetalk.Mixfile do
  use Mix.Project

  @version "0.1.10"

  def project do
    [
      app: :ueberauth_typetalk,
      name: "Ueberauth Typetalk",
      version: @version,
      package: package(),
      elixir: "~> 1.3",
      description: description(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  def application do
    [application: [:logger, :ueberauth, :oauth2]]
  end

  defp deps do
    [
      {:oauth2, "~> 0.9.4"},
      {:ueberauth, "~> 0.5"},

      # dev/test dependencies
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10.5", only: :test}
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  defp description do
    "An Ueberauth strategy for using Typetalk to authenticate your users"
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      mainterners: ["Issei Horie"],
      licenses: ["MIT"],
      links: %{Typetalk: "https://github.com/is2ei/ueberauth_typetalk"}
    ]
  end
end
