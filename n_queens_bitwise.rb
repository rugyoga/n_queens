class N_Queens
  def initialize(n)
    @N = n
    @queens = []
  end

  def northwest(file, rank)
    file + rank
  end

  def northeast(file, rank)
    file + @N - rank
  end

  def get(bitmask, i)
    (bitmask >> i) & 1 == 1
  end

  def set(bitmask, i)
    (1 << i) | bitmask
  end

  def clear(bitmask, i)
    ~(1 << i) & bitmask
  end

  def to_square(file, rank)
    file*@N+rank
  end

  def from_square(square)
    [square / @N, square % @N]
  end

  def solve(file=0, ranks=0, diag1s=0, diag2s=0, &block)
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next if get(ranks, rank)
         diag1 = northwest(file, rank)
        next if get(diag1s, diag1)
        diag2 = northeast(file, rank)
        next if get(diag2s, diag2)
        @queens.push(to_square(file, rank))
        solve(file+1,
              set(ranks, rank),
              set(diag1s, diag1),
              set(diag2s, diag2),
              &block)
        @queens.pop
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
