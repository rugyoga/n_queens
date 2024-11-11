defmodule NQueens.AsyncStream do
  @moduledoc """
  N Queens solution based on Task.async_stream.
  """
  alias NQueens.Solution

  def queen(n) do
    solve(n, [], [], [], true)
  end

  defp solve(n, rows, _, _, _) when n == length(rows) do
    [%Solution{rows: rows}]
  end

  defp solve(n, rows, nw_diags, ne_diags, async) do
    r = length(rows)
    recurse = fn {row, nw, ne} -> solve(n, [row | rows], [nw | nw_diags], [ne | ne_diags], false) end
    candidates = Enum.to_list(0..(n - 1)) -- rows
      |> Enum.map(&{&1, &1 + r, &1 - r})
      |> Enum.reject(fn {_, nw, ne} -> nw in nw_diags or ne in ne_diags end)

    if async do
      candidates
      |> Task.async_stream(recurse, ordered: false, max_concurrency: n)
      |> Enum.flat_map(fn {:ok, x} -> x end)
    else
      Enum.flat_map(candidates, recurse)
    end
  end
end
