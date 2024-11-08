defmodule NQueensSetsSimple do
  def queen(n, display \\ true) do
    solve(n, [], MapSet.new(), MapSet.new(), display)
  end

  defp solve(n, row, _, _, display) when n==length(row) do
    if display, do: print(n,row)
    1
  end
  defp solve(n, row, add_list, sub_list, display) do
    Enum.map(Enum.to_list(0..n-1) -- row, fn x ->
      add = x + length(row)             # \ diagonal check
      sub = x - length(row)             # / diagonal check
      if (add in add_list) or (sub in sub_list) do
        0
      else
        solve(n, [x|row], MapSet.put(add_list, add), MapSet.put(sub_list, sub), display)
      end
    end) |> Enum.sum                    # total of the solution
  end

  defp print(n, row) do
    Enum.each(row, fn x ->
      IO.puts Enum.map_join(0..n-1, fn i -> if x==i, do: "Q", else: "." end)
    end)
    IO.puts "\n"
  end
end

n = String.to_integer(Enum.at(System.argv, 0, "8"))
display = Enum.at(System.argv, 1, "") == "display"
IO.puts NQueensSetsSimple.queen(n, display)
