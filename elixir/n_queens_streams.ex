defmodule NQueensStream do
  def queen(n) do
    solve(n, [], 0)
  end

  defp solve(n, queens, file, rank) do
    if file==n
      [queens]
    else if rank == n
      solve(n, quuens, file+1, 0)
    else 
  end

  defp solve(n, queens, file) do
    Enum.to_list(0..n-1)
    |> Stream.filter(fn rank -> safe?(n, queens, file, rank) end)
    |> Stream.map(fn rank -> solve(n, [{file, rank} | queens], file+1) end)
    |> Stream.flat_map(fn x -> x end)
    |> Enum.sum
  end

  # defp print(solution) do
  #   Enum.each(row, fn x ->
  #     IO.puts Enum.map_join(0..n-1, fn i -> if x==i, do: "Q", else: "." end)
  #   end)
  #   IO.puts "\n"
  # end

  def northwest(_n, file, rank) do file + rank end
  def northeast(n, file, rank) do file + n - rank end

  def safe?(n, queens, file, rank) do
    Enum.all?(
      queens,
      fn {f, r} ->
        r != rank &&
        northwest(n, file, rank) != northwest(n, f, r) &&
        northeast(n, file, rank) != northeast(n, f, r)
      end)
  end
end

n = String.to_integer(Enum.at(System.argv, 0, "8"))
#_display = Enum.at(System.argv, 1, "") == "display"
Stream.each(NQueensStream.queen(n), fn solution -> IO.inspect(solution) end)
