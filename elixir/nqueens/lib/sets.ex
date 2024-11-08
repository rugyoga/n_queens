defmodule NQueens.Sets do
  def queen(n) do
    solve(n, [], MapSet.new, MapSet.new)
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_list, sub_list) do
    Stream.flat_map(
      Enum.to_list(0..(n - 1)),
      fn x ->
        r = length(row)
        add = x + r # \ diagonal check
        sub = x - r # / diagonal check
        if x in row or MapSet.member?(add_list, add) or MapSet.member?(sub_list, sub) do
          []
        else
          solve(n, [x | row], MapSet.put(add_list, add), MapSet.put(sub_list, sub))
        end
      end
    )
  end
end
