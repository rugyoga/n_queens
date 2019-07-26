require "./n_queens"

class NQueensBitarrays < NQueens
  def initialize(n : Int32)
    super(n)
    @ranks  = Array(Bool).new(n){ false }
    @northwests = Array(Bool).new(2*n){ false }
    @northeasts = Array(Bool).new(2*n){ false }
  end

  def unsafe?(file, rank)
    @ranks[rank] || @northwests[northwest(file, rank)] || @northeasts[northeast(file, rank)]
  end

  def move!(file, rank)
    super(file, rank)
    @ranks[rank] = @northwests[northwest(file, rank)] = @northeasts[northeast(file, rank)] = true
  end

  def unmove!(file, rank)
    super(file, rank)
    @ranks[rank] = @northwests[northwest(file, rank)] = @northeasts[northeast(file, rank)] = false
  end
end
