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
    @board.render_board 
    until @board.won?
      print "It's #{current_player.name}'s turn!\n"
      begin
        print "from: "
        original_piece_pos = gets.chomp!.split(",").map{|el|Integer(el)}
        @piece = @board[original_piece_pos]
        raise NoPieceError.new("no piece is here!") if @piece.nil?
      rescue NoPieceError => e
        puts e.message
        retry
      end

      begin
        print "to: "
        input = gets.chomp!
        move_sequence = convert_input(input)
        @piece.perform_moves(move_sequence)
      rescue InvalidMoveError => e 
        puts e.message
        retry
      end
        @board.render_board
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
    result << convert_single_input(str) if str.length==3 
    
    moves_str = str.split(" ")
    result = moves_str.map{|str| convert_single_input(str)}
    result
  end

  def convert_single_input(str)
    str.split(",").map{|i|Integer(i)} 
  end
end
