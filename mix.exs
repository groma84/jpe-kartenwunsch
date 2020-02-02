defmodule JpeKartenwunsch.MixProject do
  use Mix.Project

  def project do
    [
      app: :jpe_kartenwunsch,
      version: "0.2.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],
      # Docs
      name: "JPE Kartenwunsch Website",
      source_url: "https://github.com/groma84/jpe-kartenwunsch",
      homepage_url: "https://jpe.finde-ich-super.de",
      docs: [
        # The main page in the docs
        main: "JpeKartenwunsch",
        logo: "assets/static/images/notenschluessel.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {JpeKartenwunsch.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.3"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ecto, "~> 3.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:tzdata, "~> 1.0.0"},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:distillery, "~> 2.0"},
      {:phoenix_live_view, "~> 0.3.0"}
    ]
  end
end
