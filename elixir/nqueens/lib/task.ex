defmodule NQueens.Task do
  def queen(n) do
    task_solve(n, [], [], [])
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_list, sub_list) do
    r = length(row)

    0..(n - 1)
    |> Enum.map(fn x -> {x, x + r, x - r} end)
    |> Enum.reject(fn {x, add, sub} -> x in row or add in add_list or sub in sub_list end)
    |> Stream.flat_map(fn {x, add, sub} -> solve(n, [x | row], [add | add_list], [sub | sub_list]) end)
  end

  defp task_solve(n, row, add_list, sub_list) do
    r = length(row)

    0..(n - 1)
    |> Enum.map(fn x -> {x, x + r, x - r} end)
    |> Enum.reject(fn {x, add, sub} -> x in row or add in add_list or sub in sub_list end)
    |> Task.async_stream(fn {x, add, sub} -> solve(n, [x | row], [add | add_list], [sub | sub_list]) end)
    |> Stream.flat_map(fn {:ok, x} -> x end)
  end
end
