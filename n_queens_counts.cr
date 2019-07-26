require "./n_queens"

class NQueensCounts < NQueens
  def initialize(n : Int32)
    super(n)
    @attacks = Array(Array(Array(Square))).new(n) { |file| Array(Array(Square)).new(n) { |rank| attacks(file, rank) } }
    @counts  = Array(Array(Int32)).new(n) { Array.new(n) { 0 } }
  end

  def one_direction_from(squares : Array(Square), file : Index, rank : Index, file_delta : Index, rank_delta : Index)
    file += file_delta
    rank += rank_delta
    while (0 <= file && file < @N &&
           0 <= rank && rank < @N)
      squares << {file, rank}
      file += file_delta
      rank += rank_delta
    end
  end

  def attacks(file : Index, rank : Index) : Array(Square)
    squares = [{file, rank}]
    [{1,0}, {0,1}, {1,1}, {-1,1}].each do |file_delta, rank_delta|
      one_direction_from(squares, file, rank,  file_delta,  rank_delta)
      one_direction_from(squares, file, rank, -file_delta, -rank_delta)
    end
    squares
  end

  def unsafe?(file, rank)
    @counts[file][rank] > 0
  end

  def move!(file, rank)
    @queens.push({file,rank})
    @attacks[file][rank].each { |f, r| @counts[f][r] += 1 }
  end

  def unmove!(file, rank)
    @queens.pop
    @attacks[file][rank].each { |f, r| @counts[f][r] -= 1 }
  end
end
