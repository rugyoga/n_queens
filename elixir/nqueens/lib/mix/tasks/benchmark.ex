defmodule Mix.Tasks.Benchmark do
  use Mix.Task

  @shortdoc "Benchmark various N Queens solutions"

  @moduledoc """
  This is where we would put any long form documentation and doctests.
  """

  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:nqueens)

    [n_str | _rest] = args

    n = String.to_integer(n_str)

    NQueens.Solution.directory()
    |> Enum.map(fn {name, module} -> {name, fn -> module.queen(n) |> Enum.count() end} end)
    |> Benchee.run()

  end
end
