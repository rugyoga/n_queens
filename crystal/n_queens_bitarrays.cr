require "./n_queens"

class NQueensBitarrays < NQueens
  def initialize(size : Int32)
    super(size)
    @ranks  = Array(Bool).new(size){ false }
    @northwests = Array(Bool).new(2*size){ false }
    @northeasts = Array(Bool).new(2*size){ false }
  end

  def unsafe?(file, rank)
    @ranks[rank] ||
    @northwests[northwest(file, rank)] ||
    @northeasts[northeast(file, rank)]
  end

  def move!(file, rank)
    super(file, rank)
    @ranks[rank] = true
    @northwests[northwest(file, rank)] = true
    @northeasts[northeast(file, rank)] = true
  end

  def unmove!(file, rank)
    super(file, rank)
    @ranks[rank] = false
    @northwests[northwest(file, rank)] = false
    @northeasts[northeast(file, rank)] = false
  end
end
