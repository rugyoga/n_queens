defmodule NQueens.Binary do
  @moduledoc """
  N Queens solution using binary

  BROKEN

  DO NOT USE
  """
  alias NQueens.Solution

  def queen(n) do
    solve(n, [], <<0::size(2*n+1)>>, <<0::size(2*n+1)>>)
  end

  def member?(binary, offset) do
   # IO.puts("member?(#{binary}, #{offset})")
    <<_left::size(offset-1), bit::size(1), _rest::bitstring>> = binary
    bit == <<1::size(1)>>
  end

  def set(binary, offset) do
    <<left::size(offset-1), _bit::size(1), rest::bitstring>> = binary
    <<left, 1::size(1), rest::bitstring>>
  end

  defp solve(n, rows, _, _) when n == length(rows), do: [%Solution{rows: rows}]
  defp solve(n, rows, nw_diags, ne_diags) do
    r = length(rows)
    Enum.to_list(0..(n - 1)) -- rows
    |> Enum.map(&{&1, &1 + r, n + &1 - r})
    |> Enum.reject(fn {_, nw, ne} ->  member?(nw_diags, nw) or member?(ne_diags, ne) end)
    |> Enum.flat_map(fn {row, nw, ne} -> solve(n, [row | rows], set(nw_diags, nw), set(ne_diags, ne)) end)
  end
end
