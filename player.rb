require './board'
class Player
  attr_accessor :name
  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def place_check(move_sequence, board)
    board.perfom_moves(move_sequence)
  end

end
