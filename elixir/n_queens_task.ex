defmodule NQueensTask do
  def queen(n) do
    solve(n, [], [], [])
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_list, sub_list) do
    r = length(row)

    0..(n - 1)
    |> Enum.map(fn x -> {x, x + r, x - r} end)
    |> Enum.reject(fn {x, add, sub} -> x in row or add in add_list or sub in sub_list end)
    |> Task.async_stream(fn {x, add, sub} -> solve(n, [x | row], [add | add_list], [sub | sub_list]) end)
    |> Stream.flat_map(fn {:ok, x} -> x end)
  end

  def to_string({n, row}) do
    Enum.map_join(row, "\n", fn x ->
      Enum.map_join(0..(n - 1), &if(x == &1, do: "Q", else: "."))
    end) <> "\n"
  end
end

solutions = System.argv() |> Enum.at(0, "8") |> String.to_integer() |> NQueensTask.queen()

if Enum.at(System.argv(), 1, "") == "display" do
  solutions
  |> Stream.map(&NQueensTask.to_string/1)
  |> Stream.each(&IO.puts/1)
  |> Stream.run()
else
  solutions |> Enum.count() |> IO.puts
end
