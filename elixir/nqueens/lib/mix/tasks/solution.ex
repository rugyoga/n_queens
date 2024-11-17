defmodule Mix.Tasks.Solution do
  use Mix.Task

  @shortdoc "Run various N Queens solutions"

  @moduledoc """
  This is where we would put any long form documentation and doctests.
  """


  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:nqueens)
    directory = NQueens.Solution.directory()

    #try do
      [n_str | after_n] = args

      n = String.to_integer(n_str)

      [version | after_version] = after_n

      if Map.has_key?(directory, version) do
        if "display" in after_version do
          directory[version].queen(n)
          |> Stream.each(fn solution -> IO.puts solution end)
          |> Enum.count()
          |> IO.puts
        else
          directory[version].queen(n)
          |> Enum.count()
          |> IO.puts
        end
      else
        usage(directory)
      end
    #rescue e -> IO.puts inspect(e); usage(directory)
  #end
  end

  defp choices(directory) do
    directory |> Map.keys() |> Enum.join(", ")
  end

  def usage(directory) do
    IO.puts "Supply solution name as the second argument.\nOptions are: #{choices(directory)}"
    exit(1)
  end
end
