defmodule NQueens.Binary do

  def queen(n) do
    solve(n, [], <<0::n>>, <<0::n>>)
  end

  def member?(offset, binary) do
    <<bit::1, padding::(offset-1)>> = binary
    bit
  end

  def set(offset, binary) do
    <<rest, bit::1, left::(offset-1)>> = binary
    <<rest, 1::1, left>>
  end

  defp solve(n, row, _, _) when n == length(row) do
    [{n, row}]
  end

  defp solve(n, row, add_bits, sub_bits) do
    Stream.flat_map(
      Enum.to_list(0..(n - 1)),
      fn x ->
        r = length(row)
        add = x + r # \ diagonal check
        sub = x - r # / diagonal check
        if x in row or member?(add, add_bits) or member?(sub, sub_bits) do
          []
        else
          solve(n, [x | row], set(add, add_bits), set(sub, sub_bits))
        end
      end
    )
  end
end
