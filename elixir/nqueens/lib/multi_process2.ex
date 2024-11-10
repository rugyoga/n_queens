defmodule NQueens.MultiProcess2 do
  @moduledoc """
  N Queens solution using processes and streams
  """

  alias NQueens.Solution

  def queen(n) do
    solve(n, [], [], [], self(), true)
    Stream.unfold(n, &receiver/1) |> Stream.filter(& &1)
  end

  defp receiver(0), do: nil
  defp receiver(n) do
    receive do
      :finished -> {nil, n - 1}
      solution -> {solution, n}
    end
  end

  defp solve(n, rows, _, _, home, _) when n == length(rows), do: send(home, %Solution{rows: rows})
  defp solve(n, rows, nw_diags, ne_diags, home, async) do
    recurse = fn {row, nw, ne} -> solve(n, [row | rows], [nw | nw_diags], [ne | ne_diags], home, false) end
    solver = if(async, do: fn tuple -> spawn(fn -> recurse.(tuple); send(home, :finished) end) end, else: recurse)

    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, &1 - r})
    |> Enum.reject(fn {_, nw, ne} -> nw in nw_diags or ne in ne_diags end)
    |> Stream.each(solver)
    |> Stream.run()
  end
end
