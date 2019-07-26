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

  def unsafe?(file, rank, ranks, diag1s, diag2s) : Bool
    diag1 = nw(file, rank)
    diag2 = ne(file, rank)
    get(ranks, rank) || get(diag1s, diag1) || get(diag2s, diag2)
  end

  def solve(file : Index=0, ranks : Bitmask = 0, diag1s : Bitmask = 0, diag2s : Bitmask = 0, &block : Array(Square) -> Array(Square))
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next if unsafe?(file, rank, ranks, diag1s, diag2s)
        @queens.push({file, rank})
        solve(file+1, set(ranks, rank), set(diag1s, diag1), set(diag2s, diag2), &block)
        @queens.pop
      end
    end
  end

  def queens_to_board(queens : Array(Square)) : String
    board = Array.new(@N){ ['.'] * @N }
    queens.each { |queen| board[queen[1]][queen[0]] = 'Q' }
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

n_queens = N_Queens.new((ARGV[0] || 8).to_i)
display = ARGV.size > 1 && ARGV[1] == "display"
i = 0
n_queens.solve() do |queens|
  i += 1
  puts "#{i}: \n#{n_queens.queens_to_board(queens)}" if display
  queens
end
puts i unless display