require "./n_queens"

alias Diagonal = Int32
alias Position = Int32
alias Bitmask = Int32

class NQueensBitmask < NQueens
  def initialize(n : Int32)
    super(n)
    @ranks = 0
    @nws   = 0
    @nes   = 0
  end

  def get(bitmask : Bitmask, i : Position) : Bool
    (bitmask >> i) & 1 == 1
  end

  def set(bitmask : Bitmask, i : Position) : Bitmask
    (1 << i) | bitmask
  end

  def clear(bitmask : Bitmask, i : Position) : Bitmask
    ~(1 << i) & bitmask
  end

  def unsafe?(file, rank) : Bool
    get(@ranks, rank) || get(@nws, nw(file, rank)) || get(@nes, ne(file, rank))
  end

  def move!(file : Index, rank : Index)
    @queens.push({file, rank})
    @ranks = set(@ranks, rank)
    @nws   = set(@nws, nw(file, rank))
    @nes   = set(@nes, ne(file, rank))
  end

  def unmove!(file : Index, rank : Index)
    @queens.pop
    @ranks = clear(@ranks, rank)
    @nws   = clear(@nws, nw(file, rank))
    @nes   = clear(@nes, ne(file, rank))
  end
end
