require './board'
require './piece'
require './player'
require './errors'

class Game
  def initialize(player1, player2, board)
    @p1 = player1
    @p2 = player2
    @board = board
  end
  
  def play
    current_player = @p1
    print @board.render_board 
    until @board.won?
      print "It's #{current_player.name}'s turn!\n"
      print "input the marker's position"
      original_piece_pos = gets.chomp!.split(",").map{|el|Integer(el)}
      piece = @board[original_piece_pos]
      print "Input position format:x y"
      input = gets.chomp!
      move_sequence = convert_input(input)
      piece.perform_moves(move_sequence)
      print @board.render_board
      current_player = toggle(current_player)
    end
    print "win!\n"
  end

  def toggle(p1)
    p = ( p1==@p1 ) ? @p2 : @p1
    p
  end
  
  def convert_input(str)
    result = []
    result << str.split(",").map{|i|Integer(i)} if str.length == 3
    result
  end
end
