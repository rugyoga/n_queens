defmodule NQueensAsyncStream do
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

  def to_string({n, row}) do
    Enum.map_join(row, "\n", fn x ->
      Enum.map_join(0..(n - 1), &if(x == &1, do: "Q", else: "."))
    end) <> "\n"
  end
end

solutions = System.argv() |> Enum.at(0, "8") |> String.to_integer() |> NQueensAsyncStream.queen()

if Enum.at(System.argv(), 1, "") == "display" do
  solutions
  |> Stream.map(&NQueensAsyncStream.to_string/1)
  |> Stream.each(&IO.puts/1)
  |> Stream.run()
else
  solutions |> Enum.count() |> IO.puts
end
