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

  defp solve(n, rows, _, _) when n == length(rows) do
    send(self(), %Solution{rows: rows})
  end
  defp solve(n, rows, add_list, sub_list) do
    Enum.each(
      Enum.to_list(0..n-1) -- rows,
    fn row ->
      add = row + length(rows)             # \ diagonal check
      sub = row - length(rows)             # / diagonal check
      if (add not in add_list) and (sub not in sub_list) do
        solve(n, [row | rows], [add | add_list], [sub | sub_list])
      end
    end)
  end

  def receiver() do
    receive do
      :done -> []
      %Solution{} = solution -> [solution | receiver()]
    end
  end
end
