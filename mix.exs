defmodule Elixometer.Mixfile do
  use Mix.Project

  @default_elixirc_options [docs: true]

  def project do
    otp_release = :erlang.system_info(:otp_release) |> List.to_integer()
    {:ok, %Version{major: major,
      minor: minor,
      patch: patch}} = Elixir.System.version |> Elixir.Version.parse
    elixir_release = "#{major}.#{minor}.#{patch}"
    [app: :elixometer,
     description: "Elixometer is a light wrapper around exometer. It allows you to define metrics and subscribe them automatically to the default reporter for your environment.",
     version: "0.0.1",
     build_embedded: Mix.env == :prod,
     elixir: "~> 1.0",
     deps: deps,
     package: package,
     source_url: "https://github.com/pinterest/elixometer.git",
     homepage_url: "https://github.com/pinterest/elixometer.git",
     elixirc_options: elixirc_options(Mix.env), 
     test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [ mod: {Elixometer.App, []},
      applications: [:logger, :exometer],
      env: default_config(Mix.env)
    ]
  end

  def default_config(:test) do
    [update_frequency: 20]
  end

  def default_config(_) do
    [update_frequency: 1_000]
  end

  # ===================================================
  # Private functions
  # ===================================================

  defp package do
    [
      files: [
        "LICENSE",
        "mix.exs",
        "README.md",
        "lib",
        "test"
      ],
      maintainers: ["Steve Cohen <steve@pinterest.com>", "Jon Parise <jon@indelible.org>", "Add yours or others"],
      links: %{"github" => "https://github.com/pinterest/elixometer.git"},
      licenses: ["Apache"]
    ]
  end

  defp deps do
    [
     {:edown, github: "uwiger/edown", tag: "0.7", override: true},
     {:lager, github: "basho/lager", tag: "2.1.0", override: true},
     {:exometer, github: "pspdfkit-labs/exometer"},
     {:netlink, github: "Feuerlabs/netlink", ref: "d6e7188e", override: true},
     # Test dependencies
     {:excoveralls, "~> 0.3", override: true, only: :test},
     {:meck, github: "eproxus/meck", tag: "0.8.2", override: true, only: :test},
    ]
  end

  defp elixirc_options(:prod) do
    [{:debug_info, false}, {:warnings_as_errors, true}|@default_elixirc_options]
  end

  defp elixirc_options(_env) do
    @default_elixirc_options
  end
end
