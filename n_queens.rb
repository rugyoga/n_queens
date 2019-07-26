class NQueens
  def initialize(n)
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

  def self.solve_and_display(n, display)
    n_queens = new(n)
    i = 0
    n_queens.solve do |queens|
      i += 1
      puts "\n#{i}:\n#{n_queens.queens_to_board(queens)}" if display
    end
    puts i unless display
  end

  def self.solve_command
    solve_and_display((ARGV[0] || 8).to_i, ARGV.size > 1 && ARGV[1] == "display")
  end
end

NQueens.solve_command if __FILE__ == $0
