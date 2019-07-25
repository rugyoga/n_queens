alias Index = Int32
alias Square = Tuple(Index,Index)
alias Diagonal = Int32
alias Position = Int32
alias Bitmask = Int32

class N_Queens
  def initialize(n : Int32)
    @N = n
    @queens = [] of Square
  end

  def nw(file : Index, rank : Index) : Diagonal
    file + rank
  end

  def ne(file : Index, rank : Index) : Diagonal
    file + @N - rank
  end

  def get(bitmask : Bitmask, i : Position) : Bool
    (bitmask >> i) & 1 == 1
  end

  def set(bitmask : Bitmask, i : Position) : Bitmask
    (1 << i) | bitmask
  end

  def solve(file : Index=0, ranks : Bitmask = 0, diag1s : Bitmask = 0, diag2s : Bitmask = 0, &block : Array(Square) -> Array(Square))
    yield @queens if file == @N
    @N.times do |rank|
      next if get(ranks, rank)
      diag1 = nw(file, rank)
      next if get(diag1s, diag1)
      diag2 = ne(file, rank)
      next if get(diag2s, diag2)
      @queens.push({file, rank})
      solve(file+1, set(ranks, rank), set(diag1s, diag1), set(diag2s, diag2), &block)
      @queens.pop
    end
  end

  def queens_to_board(queens : Array(Square)) : String
    board = Array.new(@N){ ['.'] * @N }
    queens.each { |queen| board[queen[1]][queen[0]] = 'Q' }
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

display = ARGV.size > 1 && ARGV[1] == "display"
n_queens = N_Queens.new((ARGV[0] || 8).to_i)
i = 0
n_queens.solve() do |queens|
  i += 1
  puts "#{i}: \n#{n_queens.queens_to_board(queens)}" if display
  queens
end
puts i unless display
