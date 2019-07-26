require_relative 'n_queens'

class NQueensBitmask < NQueens
  def initialize(n)
    super(n)
    @ranks  = 0
    @nws    = 0
    @nes    = 0
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
    get?(@ranks, rank) || get?(@nws, nw(file, rank)) || get?(@nes, ne(file, rank))
  end

  def move!(file, rank)
    super(file, rank)
    @ranks = set!(@ranks, rank)
    @nws = set!(@nws, nw(file, rank))
    @nes = set!(@nes, ne(file, rank))
  end

  def unmove!(file, rank)
    super(file, rank)
    @ranks = clear!(@ranks, rank)
    @nws = clear!(@nws, nw(file, rank))
    @nes = clear!(@nes, ne(file, rank))
  end
end

NQueensBitmask.solve_command if __FILE__ == $0
