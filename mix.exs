defmodule UUID5.Mixfile do
  use Mix.Project

  @version "1.0.2"

  def project do
    [app: :uuid5,
     name: "UUID5_Ecto_Type",
     version: @version,
     elixir: "~> 1.3",
     docs: [],
     source_url: "https://github.com/anoskov/uuid5_ecto_type",
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Application configuration.
  def application do
    [
      applications: [:uuid]
    ]
  end

  # List of dependencies.
  defp deps do
    [{:uuid, "~> 1.1"},
     {:ecto, "~> 2.0"}]
  end

  # Description.
  defp description do
    """
    UUID v5 type for Ecto.
    """
  end

  # Package info.
  defp package do
    [
      name: :uuid5,
      files: ["lib", "mix.exs"],
      maintainers: ["Andrey Noskov"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/anoskov/uuid5_ecto_type"}]
  end

end
