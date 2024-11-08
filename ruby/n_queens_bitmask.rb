# frozen_string_literal: true

require_relative 'n_queens'

# https://medium.com/@guy.argo/efficient-n-queens-solution-c58706170a3a
class NQueensBitmask < NQueens
  def initialize(size)
    super(size)
    @ranks = 0
    @northwests = 0
    @northeasts = 0
  end

  def get?(bitmask, offset)
    (bitmask >> offset) & 1 == 1
  end

  def set!(bitmask, offset)
    (1 << offset) | bitmask
  end

  def clear!(bitmask, offset)
    ~(1 << offset) & bitmask
  end

  def unsafe?(file, rank)
    get?(@ranks, rank) ||
      get?(@northwests, northwest(file, rank)) ||
      get?(@northeasts, northeast(file, rank))
  end

  def move!(file, rank)
    super(file, rank)
    @ranks = set!(@ranks, rank)
    @northwests = set!(@northwests, northwest(file, rank))
    @northeasts = set!(@northeasts, northeast(file, rank))
  end

  def unmove!(file, rank)
    super(file, rank)
    @ranks = clear!(@ranks, rank)
    @northwests = clear!(@northwests, northwest(file, rank))
    @northeasts = clear!(@northeasts, northeast(file, rank))
  end
end

NQueensBitmask.solve_command if $PROGRAM_NAME == __FILE__
