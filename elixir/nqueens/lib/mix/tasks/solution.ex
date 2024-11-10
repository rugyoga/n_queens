defmodule Mix.Tasks.Solution do
  use Mix.Task

  @shortdoc "Run various N Queens solutions"

  @moduledoc """
  This is where we would put any long form documentation and doctests.
  """


  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:nqueens)

    [n_str | rest] = args

    n = String.to_integer(n_str)
    directory = NQueens.Solution.directory()
    usage = fn -> IO.puts "Supply solution name as the second argument.\nOptions are: #{directory |> Map.keys() |> Enum.join(", ")}" end

    if rest == [] do
      usage.()
    else
      which = hd(rest)
      if Map.has_key?(directory, which) do
        directory[which].queen(n)
        |> Stream.each(fn solution -> IO.puts solution end)
        |> Enum.count()
        |> IO.puts
      else
        usage.()
      end
    end
  end
end
