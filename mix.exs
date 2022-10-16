defmodule SqsDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :sqs_demo,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SqsDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway_sqs, "~> 0.7"},
      {:ex_aws_sqs, "~> 3.3"},
      {:ex_aws, "~> 2.4"},
      {:hackney, "~> 1.18"},
      {:poison, "~> 5.0"},
      {:saxy, "~> 1.1"}
    ]
  end
end
