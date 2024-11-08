# frozen_string_literal: true

require_relative 'n_queens'

# See https://medium.com/@guy.argo/efficient-n-queens-solution-c58706170a3a
class NQueensCounts < NQueens
  def initialize(size)
    super(size)
    @attacks =
      Array.new(size) do |file|
        Array.new(size) { |rank| attacks_all(file, rank) }
      end
    @counts  = Array.new(size) { Array.new(size) { 0 } }
  end

  def attacks(squares, file, rank, file_delta, rank_delta)
    file += file_delta
    rank += rank_delta
    while file >= 0 && file < @size &&
          rank >= 0 && rank < @size
      squares << [file, rank]
      file += file_delta
      rank += rank_delta
    end
  end

  def attacks_all(file, rank)
    squares = [[file, rank]]
    [[1, 0], [0, 1], [1, 1], [-1, 1]].each do |file_delta, rank_delta|
      attacks(squares, file, rank,  file_delta,  rank_delta)
      attacks(squares, file, rank, -file_delta, -rank_delta)
    end
    squares
  end

  def move!(file, rank)
    super(file, rank)
    @attacks[file][rank].each { |f, r| @counts[f][r] += 1 }
  end

  def unmove!(file, rank)
    super(file, rank)
    @attacks[file][rank].each { |f, r| @counts[f][r] -= 1 }
  end

  def unsafe?(file, rank)
    @counts[file][rank].positive?
  end
end

NQueensCounts.solve_command if $PROGRAM_NAME == __FILE__
