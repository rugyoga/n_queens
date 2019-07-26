alias Index = Int32
alias Square = Int32

class N_Queens
  def initialize(n : Int32)
    @N = n
    @attacks = Array(Array(Square)).new(n*n) { Array(Square).new(4*@N-4) }
    @counts = Array(Int32).new(n*n) { 0 }
    @queens = [] of Square
  end

  def to_square(file : Index, rank : Index) : Square
    file*@N+rank
  end

  def from_square(square : Square)  Tuple(Index, Index)
    {square / @N, square % @N}
  end

  def one_direction_from(squares : Array(Square), file : Index, rank : Index, file_delta : Index, rank_delta : Index)
    file += file_delta
    rank += rank_delta
    while (0 <= file && file < @N &&
           0 <= rank && rank < @N)
      squares << to_square(file, rank)
      file += file_delta
      rank += rank_delta
    end
  end

  def attacks(queen : Square) : Array(Square)
    file, rank = from_square(queen)
    squares = [queen]
    [{1,0}, {0,1}, {1,1}, {-1,1}].each do |file_delta, rank_delta|
      one_direction_from(squares, file, rank,  file_delta,  rank_delta)
      one_direction_from(squares, file, rank, -file_delta, -rank_delta)
    end
    squares
  end

  def memoed_attacks(queen : Square) : Array(Square)
    if (@attacks[queen].size == 0)
      @attacks[queen] = attacks(queen)
    end
    @attacks[queen]
  end

  def solve(depth : Int32=0, file : Index=0, &block : Array(Square) -> Array(Square))
    if depth == @N
      yield @queens
    else
      @N.times do |rank|
        queen = to_square(file, rank)
        next if @counts[queen] > 0
        @queens.push(queen)
        hits = memoed_attacks(queen)
        hits.each { |square| @counts[square] += 1 }
        solve(depth+1, file+1, &block)
        @queens.pop
        hits.each { |square| @counts[square] -= 1 }
      end
    end
  end

  def queens_to_board(queens : Array(Square)) : String
    board = Array(Array(Char)).new(@N){ ['.'] * @N }
    queens.map{ |q| from_square(q) }.each do |file, rank|
      board[rank][file] = 'Q'
    end
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

n_queens = N_Queens.new((ARGV[0] || 8).to_i)
display = ARGV.size > 1 && ARGV[1] == "display"
i = 0
n_queens.solve() do |queens|
  i += 1
  puts "#{i}:\n#{n_queens.queens_to_board(queens)}" if display
  queens
end
puts i unless display
