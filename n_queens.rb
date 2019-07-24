class N_Queens
  def initialize(n)
    @N = n
    @attacks  = Array.new(n*n) { nil }
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

  def solve(depth=0, file=0, &block)
    if depth == @N
      yield @queens
    else
      for rank in 0..(@N-1) do
        queen = to_square(file, rank)
        next if @counts[queen].positive?
        @queens.push(queen)
        hits = (@attacks[queen] ||= attacks(queen))
        hits.each { |square| @counts[square] += 1 }
        solve(depth+1, file+1, &block)
        @queens.pop
        hits.each { |square| @counts[square] -= 1 }
      end
    end
  end

  def square_to_s(square)
    file, rank = from_square(square)
    "#{(file+"a".ord).chr}#{rank+1}"
  end

  def squares_to_s(squares)
    "[#{squares.map{|square| square_to_s(square) }.join(', ')}]"
  end

  def queens_to_board(queens)
    board = Array.new(@N){ ['.'] * @N }
    queens.each do |queen|
      file, rank = from_square(queen)
      board[rank][file] = "Q"
    end
    board.reverse.map{ |rank| rank.join('') }.join("\n")
  end
end

N = (ARGV[0] || 8).to_i
n_queens = N_Queens.new(N)
i = 0
n_queens.solve do |queens|
  puts "#{i += 1}:"
  puts n_queens.squares_to_s(queens)
  puts n_queens.queens_to_board(queens)
end
