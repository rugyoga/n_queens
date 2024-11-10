defmodule NQueens.Process do
  @moduledoc """
  N Quens implementation using the process mailbox and no paralleism.
  """
  alias NQueens.Solution

  def queen(n) do
    solve(n, [], [], [])
    send(self(), :done)
    receiver()
  end

  def receiver() do
    receive do
      :done -> []
      %Solution{} = solution -> [solution | receiver()]
    end
  end

  defp solve(n, rows, _, _) when n == length(rows) do
    send(self(), %Solution{rows: rows})
  end
  defp solve(n, rows, nw_diags, ne_diags) do
    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, &1 - r})
    |> Enum.reject(fn {_, nw, ne} -> nw in nw_diags or ne in ne_diags end)
    |> Enum.each(fn {row, nw, ne} -> solve(n, [row | rows], [nw | nw_diags], [ne | ne_diags]) end)
  end
end
