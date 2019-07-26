class N_Queens
  attr_accessor :calls

  def initialize(n)
    @calls = 0
    @N = n
    @queens = []
  end

  def nw(file, rank)
    file + rank
  end

  def ne(file, rank)
    file + @N - rank
  end

  def unsafe?(file, rank)
    @queens.any?{ |f, r| r == rank || nw(f, r) == nw(file, rank) || ne(f, r) == ne(file, rank) }
  end

  def move!(file, rank)
    @queens.push([file, rank])
  end

  def unmove!(file, rank)
    @queens.pop
  end

  def solve(file=0, &block)
    @calls += 1
    if file == @N
      yield @queens
    else
      @N.times do |rank|
        next if unsafe?(file, rank)
        move!(file, rank)
        solve(file+1, &block)
        unmove!(file, rank)
      end
    end
  end

  def queens_to_board(queens)
    board = Array.new(@N){ ['.'] * @N }
    queens.each { |file, rank| board[rank][file] = 'Q' }
    board.reverse.map{ |rank| rank.join("") }.join("\n")
  end
end

N = (ARGV[0] || 8).to_i
display = ARGV.size > 1 && ARGV[1] == "display"
n_queens = N_Queens.new(N)
i = 0
n_queens.solve do |queens|
  i += 1
  puts "\n#{i}/#{n_queens.calls}: \n#{n_queens.queens_to_board(queens)}" if display
end
puts "#{i}/#{n_queens.calls}" unless display
