defmodule NQueens.Bitwise do
  @moduledoc """
  N Queens solution based on Bitwise operators
  """
  alias NQueens.Solution

  import Bitwise

  def queen(n) do
    solve(n, [], 0b0, 0b0)
  end

  defp member?(bits, bit), do: ((bits >>> bit) &&& 0b1) == 0b1
  defp set(bits, bit), do: bits ||| (0b1 <<< bit)

  defp solve(n, rows, _, _) when n == length(rows) do
    [%Solution{rows: rows}]
  end

  defp solve(n, rows, _, _) when n == length(rows), do: [%Solution{rows: rows}]
  defp solve(n, rows, nw_diags, ne_diags) do
    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, n + &1 - r})
    |> Enum.reject(fn {_, nw, ne} ->  member?(nw_diags, nw) or member?(ne_diags, ne) end)
    |> Enum.flat_map(fn {row, nw, ne} -> solve(n, [row | rows], set(nw_diags, nw), set(ne_diags, ne)) end)
  end
end
