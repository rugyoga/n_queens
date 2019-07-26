require_relative 'n_queens'

class NQueensCounts < NQueens
  def initialize(n)
    super(n)
    @attacks = Array.new(n) { |file| Array.new(n){ |rank| attacks_all(file, rank) } }
    @counts  = Array.new(n) { Array.new(n) { 0 } }
  end

  def attacks(squares, file, rank, file_delta, rank_delta)
    file += file_delta
    rank += rank_delta
    while (0 <= file && file < @N &&
           0 <= rank && rank < @N) do
      squares << [file, rank]
      file += file_delta
      rank += rank_delta
    end
  end

  def attacks_all(file, rank)
    squares = [[file, rank]]
    [[1,0], [0,1], [1,1], [-1,1]].each do |file_delta, rank_delta|
      attacks(squares, file, rank,  file_delta,  rank_delta)
      attacks(squares, file, rank, -file_delta, -rank_delta)
    end
    squares
  end

  def move!(file, rank)
    super(file, rank)
    @attacks[file][rank].each { |f,r| @counts[f][r] += 1 }
  end

  def unmove!(file, rank)
    super(file, rank)
    @attacks[file][rank].each { |f,r| @counts[f][r] -= 1 }
  end

  def unsafe?(file, rank)
    @counts[file][rank] > 0
  end
end

NQueensCounts.solve_command if __FILE__ == $0