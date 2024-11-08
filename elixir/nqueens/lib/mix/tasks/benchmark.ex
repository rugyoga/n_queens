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

    Benchee.run(
      %{
        "async_stream" => fn -> NQueens.AsyncStream.queen(n) |> Enum.count() end,
        "bitmask" => fn -> NQueens.Binary.queen(n) |> Enum.count() end,
        "bitmask" => fn -> NQueens.Bitmask.queen(n) |> Enum.count() end,
        "enum" => fn -> NQueens.Enum.queen(n) |> Enum.count() end,
        "multi_process" => fn -> NQueens.MultiProcess.queen(n) |> Enum.count() end,
        "process" => fn -> NQueens.Process.queen(n) |> Enum.count() end,
        "sets" => fn -> NQueens.Sets.queen(n) |> Enum.count() end,
        "streams" => fn -> NQueens.Streams.queen(n) |> Enum.count() end,
        "task" => fn -> NQueens.Task.queen(n) |> Enum.count() end
      }
    )
  end
end
