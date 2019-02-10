defmodule UeberauthTypetalk.Mixfile do
  use Mix.Project

  @version "0.1.3"

  def project do
    [
      app: :ueberauth_typetalk,
      version: @version,
      name: "Ueberauth Typetalk",
      package: package(),
      elixir: "~> 1.3",
      description: description(),
      deps: deps(),
      docs: docs(),
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
      links: %{"Typetalk": "https://github.com/is2ei/ueberauth_typetalk"}
    ]
  end
end