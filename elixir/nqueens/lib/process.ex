defmodule NQueens.Process do
  def queen(n) do
    solve(n, [], [], [])
    send(self(), :done)
    receiver()
  end

  defp solve(n, row, _, _) when n==length(row) do
    send(self(), row)
  end
  defp solve(n, row, add_list, sub_list) do
    Enum.each(Enum.to_list(0..n-1) -- row, fn x ->
      add = x + length(row)             # \ diagonal check
      sub = x - length(row)             # / diagonal check
      if (add not in add_list) and (sub not in sub_list) do
        solve(n, [x|row], [add | add_list], [sub | sub_list])
      end
    end)
  end

  def receiver() do
    receive do
      :done -> []
      solution -> [solution | receiver()]
    end
  end
end
