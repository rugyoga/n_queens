alias Index = Int32
alias Square = Tuple(Index, Index)

class NQueens
  def initialize(n : Index)
    @N = n
    @queens = [] of Square
  end

  def northwest(file : Index, rank : Index) : Index
    file + rank
  end

  def northeast(file : Index, rank : Index) : Index
    file + @N - rank
  end

  def unsafe?(file : Index, rank : Index) : Bool
    @queens.any? do |f, r|
      r == rank ||
      northwest(f, r) == northwest(file, rank) ||
      northeast(f, r) == northeast(file, rank)
    end
  end

  def move!(file, rank)
    @queens.push({file, rank})
  end

  def unmove!(file, rank)
    @queens.pop
  end

  def solve(file : Index = 0, &block : NQueens -> NQueens)
    if file == @N
      yield self
    else
      @N.times do |rank|
        next if unsafe?(file, rank)
        move!(file, rank)
        solve(file+1, &block)
        unmove!(file, rank)
      end
    end
  end

  def to_s : String
    board = Array.new(@N){ ['.'] * @N }
    @queens.each { |file, rank| board[rank][file] = 'Q' }
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end

  def self.solve_and_display(n : Index, display : Bool)
    i = 0
    new(n).solve do |queens|
      i += 1
      puts "\n#{i}:\n#{queens.to_s}" if display
      queens
    end
    puts i unless display
  end

  def self.solve_command
    solve_and_display((ARGV[0] || 8).to_i, ARGV.size > 1 && ARGV[1] == "display")
  end
end
