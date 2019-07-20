require 'set'

class N_Queens
  def initialize(n)
    @N = n
    @attacks  = Array.new(n*n) { nil }
    @counts = Array.new(n*n) { 0 }
    @queens = []
    @solutions = []
    @type = :first
  end

  def to_square(i,j)
    i*@N+j
  end

  def from_square(square)
    [square / @N, square % @N]
  end

  def one_direction_from(squares, i_next, j_next, i_delta, j_delta)
    i_next += i_delta
    j_next += j_delta
    while (0 <= i_next && i_next < @N &&
           0 <= j_next && j_next < @N) do
      squares << to_square(i_next, j_next)
      i_next += i_delta
      j_next += j_delta
    end
  end

  def attacks(sq)
    i_next, j_next = from_square(sq)
    squares = [sq]
    [[1,0], [0,1], [1,1], [-1,1]].each do |i_delta, j_delta|
      one_direction_from(squares, i_next, j_next,  i_delta,  j_delta)
      one_direction_from(squares, i_next, j_next, -i_delta, -j_delta)
    end
    squares
  end

  def place_queens(depth=0, i=0)
    if depth == @N
      @solutions << @queens.clone
      return
    end
    for j in 0..(@N-1) do
      candidate = to_square(i,j)
      next if @counts[candidate].positive?
      @queens.push(candidate)
      hits = (@attacks[candidate] ||= attacks(candidate))
      hits.each { |sq| @counts[sq] += 1 }
      result = place_queens(depth+1, i+1)
      return if @type == :first && !@solutions.empty?
      @queens.pop
      hits.each { |sq| @counts[sq] -= 1 }
    end
    nil
  end

  def solve_first
    @type = :first
    place_queens
    @solutions.first
  end

  def solve_all
    @type = :all
    place_queens
    @solutions
  end

  def set_to_s(set)
    set.nil? ? "nil" : "[#{set.map{|sq| from_square(sq).inspect }.join(', ')}]"
  end

  def set_to_board(set)
    board = Array.new(set.size){ ['.'] * set.size }
    set.each do |sq|
      i, j = from_square(sq)
      board[i][j] = "Q"
    end
    board.map{ |row| row.join('') }.join("\n")
  end
end

N = (ARGV[0] || 8).to_i
n_queens = N_Queens.new(N)
solutions = n_queens.solve_all
solutions.each_with_index do |solution, i|
  puts "#{i}:"
  puts n_queens.set_to_s(solution)
  puts n_queens.set_to_board(solution)
end
