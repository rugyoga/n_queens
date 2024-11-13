defmodule NQueens.Solution do
  @moduledoc """
  struct for returning results and pretty printer
  plus directory opf solution
  """
  defstruct [:rows]

  defimpl String.Chars, for: NQueens.Solution do
    def to_string(%NQueens.Solution{rows: rows}) do
      n = length(rows)
      Enum.map_join(rows, "\n", fn x ->
        Enum.map_join(0..(n - 1), &if(x == &1, do: "Q", else: "."))
      end) <> "\n"
    end
  end

  def directory() do
    %{
      "async_stream"  => NQueens.AsyncStream,
      "async_stream2" => NQueens.AsyncStream2,
      # "binary"        => NQueens.Binary, broken
      "bitwise"       => NQueens.Bitwise,
      "enum"          => NQueens.Enum,
      "multi_process" => NQueens.MultiProcess,
      "multi_process2" => NQueens.MultiProcess2,
      "process"       => NQueens.Process,
      "mapset"        => NQueens.MapSet,
      "streams"       => NQueens.Streams,
    }
  end
end
