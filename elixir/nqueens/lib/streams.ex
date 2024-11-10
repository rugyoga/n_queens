defmodule NQueens.Streams do
  @moduledoc """
  N Queens solution based on Enum
  """
  alias NQueens.Solution

  def queen(n) do
    solve(n, [], [], [])
  end

  defp solve(n, rows, _, _) when n == length(rows), do: [%Solution{rows: rows}]
  defp solve(n, rows, nw_diags, ne_diags) do
    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, &1 - r})
    |> Enum.reject(fn {_, nw, ne} -> nw in nw_diags or ne in ne_diags end)
    |> Stream.flat_map(fn {row, nw, ne} -> solve(n, [row | rows], [nw | nw_diags], [ne | ne_diags]) end)
  end
end
