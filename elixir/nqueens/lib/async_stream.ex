defmodule NQueens.AsyncStream do
  def queen(n) do
    solve(n, [], [], [])
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_list, sub_list) do
    r = length(row)
    worker =
      fn x ->
        add = x + r # \ diagonal check
        sub = x - r # / diagonal check
        if x in row or add in add_list or sub in sub_list do
          []
        else
          solve(n, [x | row], [add | add_list], [sub | sub_list])
        end
      end
    if n - r > 8 do
      0..(n - 1)
      |> Task.async_stream(worker)
      |> Stream.flat_map(fn {:ok, x} -> x end)
    else
      Stream.flat_map(0..(n - 1), worker)
    end
  end
end
