require 'set'

def square(i,j)
  [i,j]
end

def one_direction_from(n, i, j, i_delta, j_delta)
  i_next, j_next = i+i_delta, j+j_delta
  attacked = Set.new
  while (0 <= i_next && i_next < n &&
         0 <= j_next && j_next < n) do
    attacked.add(square(i_next, j_next))
    i_next += i_delta
    j_next += j_delta
  end
  attacked
end

ATTACKED_BY = {}

def attacked_by(n, square)
  i, j = square
  attacked = Set.new
  attacked.add(square)
  [[1,0], [0,1], [1,1], [-1,1]].each do |i_delta, j_delta|
    attacked = attacked.merge(one_direction_from(n, i, j,  i_delta,  j_delta))
                       .merge(one_direction_from(n, i, j, -i_delta, -j_delta))
  end
  attacked
end

def cached_attacked_by(n, square)
  (ATTACKED_BY[square] ||= attacked_by(n, square)).clone
end

def new_attacked_by(n, square, attacked)
  cached_attacked_by(n, square).delete_if{ |square| attacked.member?(square) }
end

def place_queen(n, depth, i, placed=Set.new, attacked=Set.new)
  return placed if depth == n
  for j in 0..(n-1) do
    candidate = square(i,j)
    next if attacked.member?(candidate)
    placed.add(candidate)
    new_hits = new_attacked_by(n, candidate, attacked)
    attacked = attacked.merge(new_hits)
    result = place_queen(n, depth+1, i+1, placed, attacked)
    return result if !result.nil?
    placed.delete(candidate)
    attacked = attacked.subtract(new_hits)
  end
  nil
end

def set_to_s(set)
  set.nil? ? "nil" : "[#{set.map{|square| square.inspect }.join(', ')}]"
end

def set_to_board(set)
  board = Array.new(set.size){ ['.'] * set.size }
  set.each{ |square| board[square[0]][square[1]] = "Q" }
  board.map{ |row| row.join('') }.join("\n")
end

N = (ARGV[0] || 8).to_i
solution = place_queen(N, 0, 0)
puts set_to_s(solution)
puts set_to_board(solution)
