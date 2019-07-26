class N_Queens
  def initialize(n)
    @N = n
    @attacks = Array.new(n*n) { nil }
    @counts = Array.new(n*n) { 0 }
    @queens = []
  end

  def to_square(file, rank)
    file*@N+rank
  end

  def from_square(square)
    [square / @N, square % @N]
  end

  def one_direction_from(squares, file, rank, file_delta, rank_delta)
    file += file_delta
    rank += rank_delta
    while (0 <= file && file < @N &&
           0 <= rank && rank < @N) do
      squares << to_square(file, rank)
      file += file_delta
      rank += rank_delta
    end
  end

  def attacks(queen)
    file, rank = from_square(queen)
    squares = [queen]
    [[1,0], [0,1], [1,1], [-1,1]].each do |file_delta, rank_delta|
      one_direction_from(squares, file, rank,  file_delta,  rank_delta)
      one_direction_from(squares, file, rank, -file_delta, -rank_delta)
    end
    squares
  end

  def solve(file=0, &block)
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        queen = to_square(file, rank)
        next if @counts[queen] > 0
        @queens.push(queen)
        hits = (@attacks[queen] ||= attacks(queen))
        hits.each { |square| @counts[square] += 1 }
        solve(file+1, &block)
        @queens.pop
        hits.each { |square| @counts[square] -= 1 }
      end
    end
  end

  def queens_to_board(queens)
    board = Array.new(@N){ ['.'] * @N }
    queens.each do |queen|
      file, rank = from_square(queen)
      board[rank][file] = 'Q'
    end
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

N = (ARGV[0] || 8).to_i
display = ARGV.size > 1 && ARGV[1] == "display"
n_queens = N_Queens.new(N)
i = 0
n_queens.solve do |queens|
  i += 1
  puts "#{i}: \n#{n_queens.queens_to_board(queens)}" if display
end
puts i unless display
