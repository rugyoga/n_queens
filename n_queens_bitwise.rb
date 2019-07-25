class N_Queens
  def initialize(n)
    @N = n
    @properties = {rank: 0, northwest: 0, northeast: 0}
    @queens = []
  end

  def test_and_set(file, rank)
    return false if get(@properties[:rank], rank)
    nw = northwest(file, rank)
    return false if get(@properties[:northwest], nw)
    ne = northeast(file, rank)
    return false if get(@properties[:northeast], ne)
    @properties[:rank]      = set(@properties[:rank], rank)
    @properties[:northwest] = set(@properties[:northwest], nw)
    @properties[:northeast] = set(@properties[:northeast], ne)
    true
  end

  def clear_all(file, rank)
    @properties[:rank]      = clear(@properties[:rank], rank)
    @properties[:northwest] = clear(@properties[:northwest], northwest(file, rank))
    @properties[:northeast] = clear(@properties[:northeast], northeast(file, rank))
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

  def solve(depth=0, file=0, &block)
    if depth == @N
      yield @queens
    else
      for rank in 0..(@N-1) do
        if test_and_set(file, rank)
          @queens.push(to_square(file, rank))
          solve(depth+1, file+1, &block)
          clear_all(file, rank)
          @queens.pop
        end
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
