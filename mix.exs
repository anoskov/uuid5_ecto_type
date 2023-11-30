defmodule UUID5.Mixfile do
  use Mix.Project

  @version "1.2.0"

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
      applications: []
    ]
  end

  # List of dependencies.
  defp deps do
    [{:elixir_uuid, "~> 1.2"},
     {:ecto, "~> 2.0 or ~> 3.0", optional: true},
     {:ex_doc, ">= 0.0.0", only: :dev}]
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
