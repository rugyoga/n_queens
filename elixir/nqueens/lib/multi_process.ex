defmodule NQueens.MultiProcess do
  def queen(n) do
    solve(n, [], [], [], self(), true)
    Stream.unfold(n, &receiver/1) |> Stream.filter(& &1)
  end

  defp solve(n, row, _, _, home, _) when n==length(row) do
    send(home, {:solution, row})
  end
  defp solve(n, row, add_list, sub_list, home, async) do
    solver = fn x ->
      add = x + length(row)             # \ diagonal check
      sub = x - length(row)             # / diagonal check
      if (add not in add_list) and (sub not in sub_list) do
        solve(n, [x | row], [add | add_list], [sub | sub_list], home, false)
      end
    end
    remaining = Enum.to_list(0..n-1) -- row
    if async do
      Enum.each(remaining, fn x -> spawn(fn -> solver.(x); send(home, :finished) end) end)
    else
      Enum.each(remaining, solver)
    end
  end

  defp receiver(0), do: nil
  defp receiver(n) do
    receive do
      :finished -> {nil, n - 1}
      {:solution, solution} -> {solution, n}
    end
  end
end
