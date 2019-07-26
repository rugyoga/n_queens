require_relative 'n_queens'

class NQueensBitmask < NQueens
  def initialize(n)
    super(n)
    @ranks  = 0
    @diag1s = 0
    @diag2s = 0
  end

  def get(bitmask, offset)
    (bitmask >> offset) & 1 == 1
  end

  def set(bitmask, offset)
    (1 << offset) | bitmask
  end

  def clear(bitmask, offset)
    ~(1 << offset) & bitmask
  end

  def unsafe?(file, rank)
    get(@ranks, rank) || get(@diag1s, nw(file, rank)) || get(@diag2s, ne(file, rank))
  end

  def move!(file, rank)
    @ranks  = set(@ranks, rank)
    @diag1s = set(@diag1s, nw(file, rank))
    @diag2s = set(@diag2s, ne(file, rank))
    @queens.push([file, rank])
  end

  def unmove!(file, rank)
    @queens.pop
    @ranks  = clear(@ranks, rank)
    @diag1s = clear(@diag1s, nw(file, rank))
    @diag2s = clear(@diag2s, ne(file, rank))
  end
end

NQueensBitmask.solve_command if __FILE__ == $0
