defmodule NQueens.Enum do
  def queen(n) do
    solve(n, [], [], [])
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_list, sub_list) do
    Enum.flat_map(
      Enum.to_list(0..(n - 1)),
      fn x ->
        r = length(row)
        add = x + r # \ diagonal check
        sub = x - r # / diagonal check
        if x in row or add in add_list or sub in sub_list do
          []
        else
          solve(n, [x | row], [add | add_list], [sub | sub_list])
        end
      end
    )
  end
end
