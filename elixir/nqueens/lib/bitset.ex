defmodule NQueens.Bitset do
  @moduledoc """
  N Queens solution based on Bitwise operators
  """
  alias NQueens.Solution

  def queen(n) do
    solve(n, [], Bitset.new(2 * n - 1), Bitset.new(2 * n - 1))
  end

  defp solve(n, rows, _, _) when n == length(rows), do: [%Solution{rows: rows}]
  defp solve(n, rows, nw_diags, ne_diags) do
    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, n + &1 - r})
    |> Enum.reject(fn {_, nw, ne} ->  Bitset.test?(nw_diags, nw) or Bitset.test?(ne_diags, ne) end)
    |> Enum.flat_map(fn {row, nw, ne} -> solve(n, [row | rows], Bitset.set(nw_diags, nw), Bitset.set(ne_diags, ne)) end)
  end
end
