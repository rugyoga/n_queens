# frozen_string_literal: true

# See https://medium.com/@guy.argo/efficient-n-queens-solution-c58706170a3a
class NQueens
  def initialize(size)
    @size = size
    @queens = []
  end

  def northwest(file, rank)
    file + rank
  end

  def northeast(file, rank)
    file + @size - rank
  end

  def unsafe?(file, rank)
    @queens.any? do |f, r|
      r == rank ||
        northwest(f, r) == northwest(file, rank) ||
        northeast(f, r) == northeast(file, rank)
    end
  end

  def move!(file, rank)
    @queens.push([file, rank])
  end

  def unmove!(_file, _rank)
    @queens.pop
  end

  def solve(file = 0, &block)
    if file == @size
      yield self
    else
      @size.times do |rank|
        next if unsafe?(file, rank)

        move!(file, rank)
        solve(file + 1, &block)
        unmove!(file, rank)
      end
    end
  end

  def to_s
    board = Array.new(@size) { ['.'] * @size }
    @queens.each { |file, rank| board[rank][file] = 'Q' }
    board.reverse.map { |rank| rank.join('') }.join("\n")
  end

  def self.solve_and_display(size, display)
    i = 0
    new(size).solve do |queens|
      i += 1
      puts "\n#{i}:\n#{queens}" if display
    end
    puts i unless display
  end

  def self.solve_command
    solve_and_display(
      (ARGV[0] || 8).to_i,
      ARGV.size > 1 && ARGV[1] == 'display'
    )
  end
end

NQueens.solve_command if $PROGRAM_NAME == __FILE__
