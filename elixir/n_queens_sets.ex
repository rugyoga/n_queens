defmodule NQueensSets do
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

  def to_string({n, row}) do
    "\n" <>
      Enum.map_join(row, "\n", fn x ->
        Enum.map_join(0..(n - 1), &if(x == &1, do: "Q", else: "."))
      end)
  end
end

solutions =
  System.argv()
  |> Enum.at(0, "8")
  |> String.to_integer()
  |> NQueensSets.queen()

if Enum.at(System.argv(), 1, "") == "display" do
  solutions
  |> Stream.map(&NQueensSets.to_string/1)
  |> Stream.each(&IO.puts/1)
  |> Stream.run()
else
  solutions |> Enum.count() |> IO.puts
end
