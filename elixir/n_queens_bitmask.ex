defmodule N_Queens do
  def queen(n, display \\ true) do
    solve(n, [], [], [], display)
  end

  def get(bitmask, offset) do
    ((bitmask >>> offset) &&& 1) == 1
  end

  def set(bitmask, offset) do
    (1 <<< offset) ||| bitmask
  end

  def clear(bitmask, offset) do
    ~~~(1 <<< offset) &&& bitmask
  end

  def unsafe(file, rank) do
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
        solve(n, [x|row], [add | add_list], [sub | sub_list], display)
      end
    end) |> Enum.sum                    # total of the solution
  end

  defp print(n, row) do
    IO.puts frame = "+" <> String.duplicate("-", 2*n+1) <> "+"
    Enum.each(row, fn x ->
      line = Enum.map_join(0..n-1, fn i -> if x==i, do: "Q", else: ". " end)
      IO.puts "| #{line}|"
    end)
    IO.puts frame
  end
end

n = String.to_integer(Enum.at(System.argv, 0, "8"))
display = Enum.at(System.argv, 1, "") == "display"
IO.puts N_Queens.queen(n, display)
