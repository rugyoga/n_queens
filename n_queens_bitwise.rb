class N_Queens
  def initialize(n)
    @N = n
    @queens = []
  end

  def get(bitmask, i)
    (bitmask >> i) & 1 == 1
  end

  def set(bitmask, i)
    (1 << i) | bitmask
  end

  def nw(file, rank)
    file + rank
  end

  def ne(file, rank)
    file + @N - rank
  end

  def solve(file=0, ranks=0, diag1s=0, diag2s=0, &block)
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next if get(ranks, rank) || get(diag1s, diag1 = nw(file, rank)) || get(diag2s, diag2 = ne(file, rank))
        @queens.push([file, rank])
        solve(file+1, set(ranks, rank), set(diag1s, diag1), set(diag2s, diag2),&block)
        @queens.pop
      end
    end
  end

  def queens_to_board(queens)
    board = Array.new(@N){ ['.'] * @N }
    queens.each { |queen| board[queen[1]][queen[0]] = 'Q' }
    board.reverse.map{ |rank| rank.join('') }.join("\n")
  end
end

i = 0
n_queens = N_Queens.new((ARGV[0] || 8).to_i)
display = ARGV.size > 1 && ARGV[1] == "display"
n_queens.solve do |queens|
  i += 1
  puts "\n#{i}:\n#{n_queens.queens_to_board(queens)}\n" if display
end
puts i unless display
