alias Index = Int32
alias Square = Tuple(Index,Index)
alias Diagonal = Int32
alias Position = Int32
alias Bitmask = Int32

class N_Queens
  def initialize(n : Int32)
    @N = n
    @queens = [] of Square
    @ranks  = Array(Bool).new(n){ false }
    @diag1s = Array(Bool).new(2*n){ false }
    @diag2s = Array(Bool).new(2*n){ false }
  end

  def nw(file : Index, rank : Index) : Diagonal
    file + rank
  end

  def ne(file : Index, rank : Index) : Diagonal
    file + @N - rank
  end

  def solve(file : Index=0, &block : Array(Square) -> Array(Square))
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next if @ranks[rank]
        diag1 = nw(file, rank)
        next if @diag1s[diag1]
        diag2 = ne(file, rank)
        next if @diag2s[diag2]
        @queens.push({file, rank})
        @ranks[rank] = @diag1s[diag1] = @diag2s[diag2] = true
        solve(file+1, &block)
        @ranks[rank] = @diag1s[diag1] = @diag2s[diag2] = false
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
