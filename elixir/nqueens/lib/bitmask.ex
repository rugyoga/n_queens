defmodule NQueens.Bitmask do
  use Bitwise

  def queen(n) do
    solve(n, [], 0b0, 0b0)
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  def member?(bits, bit), do: (bits &&& (0b1 <<< bit)) != 0b0
  def set(bits, bit), do: bits ||| (0b1 <<< bit)

  defp solve(n, row, add_bits, sub_bits) do
    Stream.flat_map(
      Enum.to_list(0..(n - 1)),
      fn x ->
        r = length(row)
        add = x + r # \ diagonal check
        sub = x - r # / diagonal check
        if x in row or member?(add_bits, add) or member?(sub_bits, sub) do
          []
        else
          solve(n, [x | row], set(add_bits, add), set(sub_bits, sub))
        end
      end
    )
  end
end
