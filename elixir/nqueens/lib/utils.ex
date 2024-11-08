defmodule NQueens.Utils do
  def print(n, row) do
    Enum.each(row, fn x ->
      IO.puts Enum.map_join(0..n-1, fn i -> if x==i, do: "Q", else: "." end)
    end)
    IO.puts "\n"
  end

  def to_string({n, row}) do
    Enum.map_join(row, "\n", fn x ->
      Enum.map_join(0..(n - 1), &if(x == &1, do: "Q", else: "."))
    end) <> "\n"
  end
end
