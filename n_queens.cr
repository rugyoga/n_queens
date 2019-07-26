alias Index = Int32
alias Square = Tuple(Index, Index)

class N_Queens
  def initialize(n : Index)
    @N = n
    @queens = [] of Square
  end

  def nw(file : Index, rank : Index) : Index
    file + rank
  end

  def ne(file : Index, rank : Index) : Index
    file + @N - rank
  end

  def safe?(file : Index, rank : Index) : Bool
    @queens.all?{ |f, r| r != rank && nw(f, r) != nw(file, rank) && ne(f, r) != ne(file, rank) }
  end

  def solve(file : Index = 0, &block : Array(Square) -> Array(Square))
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next unless safe?(file, rank)
        @queens.push({file, rank})
        solve(file+1, &block)
        @queens.pop
      end
    end
  end

  def queens_to_board(queens : Array(Square)) : String
    board = Array.new(@N){ ['.'] * @N }
    queens.each { |file, rank| board[rank][file] = 'Q' }
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

N = (ARGV[0] || 8).to_i
display = ARGV.size > 1 && ARGV[1] == "display"
n_queens = N_Queens.new(N)
i = 0
n_queens.solve do |queens|
  i += 1
  puts "\n#{i}: \n#{n_queens.queens_to_board(queens)}" if display
  queens
end
puts "#{i}" unless display
