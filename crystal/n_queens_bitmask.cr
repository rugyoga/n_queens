require "./n_queens"

alias Position = Int32
alias Bitmask = Int32

class NQueensBitmask < NQueens
  def initialize(size : Int32)
    super(size)
    @ranks = 0
    @northwests = 0
    @northeasts = 0
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

  def unsafe?(file : Bitmask, rank : Bitmask) : Bool
    get(@ranks, rank) ||
    get(@northwests, northwest(file, rank)) ||
    get(@northeasts, northeast(file, rank))
  end

  def move!(file : Index, rank : Index)
    super(file, rank)
    @ranks = set(@ranks, rank)
    @northwests = set(@northwests, northwest(file, rank))
    @northeasts = set(@northeasts, northeast(file, rank))
  end

  def unmove!(file : Index, rank : Index)
    super(file, rank)
    @ranks = clear(@ranks, rank)
    @northwests = clear(@northwests, northwest(file, rank))
    @northeasts = clear(@northeasts, northeast(file, rank))
  end
end
