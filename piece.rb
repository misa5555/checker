require './errors'

class Piece
  attr_accessor :pos
  attr_reader :color
  
  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
    @king = false
  end
  
  # pos is absolute coordinate
  # to_pos is array [a, b]
  def perform_slide(to_pos)
    return false unless check_move(to_pos, 1) 
    
    current_pos = @pos
    @pos = to_pos
    @board[current_pos] = nil
    @board[@pos] = self
    return true
  end

  def perform_jump(to_pos)
    return false unless check_move(to_pos, 2) 
    
    #check if piece in to_pos is different color
    jumped_pos = between_pos(@pos, to_pos)
    jumped_piece = @board[jumped_pos]
    return false if jumped_piece.color == self.color
    
    # piece jumps to to_pos
    current_pos = @pos
    @board[jumped_pos] = nil 
    @board[current_pos] = nil
    @pos = to_pos
    @board[@pos] = self
    return true
  end

  # move sequence [[a,b], [c,d]...]
  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      unless perform_slide(move_sequence[0]) 
        unless perform_jump(move_sequence[0]) 
          raise InvalidMoveError.new("wrong move")
        end
      end
    else
      move_sequence.each do |move|
        unless perform_jump(move)
          raise InvalidMoveError.new("jump interrupted")
          break
        end
      end
    end
    return 
  end
  
  def perform_moves(move_sequence)
      raise InvalidMoveError unless valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
  end

  def valid_move_seq?(seq)
    dup_board = @board.dup
    dup_piece = dup_board[@pos] 
    begin dup_piece.perform_moves!(seq)
    rescue InvalidMoveError => e
      return false
    end  
    return true
  end

  def maybe_promote
    
  end
  
  def render
    return "B" if @color == :black
    return "W" if @color == :white
  end

  def dup(board)
    Piece.new(@pos, @color, board)
  end

  private
  def move_diffs
    black_move = [[1, 1], [1, -1]]
    white_move = [[-1,1], [-1, -1]]
    unless @king
      return black_move if @color == :black
      return white_move if @color == :white
    else
      return black_move + white_move
    end
  end
  
  def multipled_vectors(vectors, n)
    multipled_vectors = []
    vectors.each do |vector|
      multipled_vectors << [vector[0] * n, vector[1] * n]
    end
    multipled_vectors
  end

  def between_pos(pos1, pos2)
    [( pos1[0]+ pos2[0])/2, (pos1[1]+pos2[1])/2 ].map{|elem| elem.to_i}
  end
  
  def in_boudary?(pos)
    pos.all?{|coord| coord.between?(0, 7)}  
  end
  
  def check_move(to_pos, n)
    # check if new position is in boudary
    return false unless in_boudary?(to_pos)
    
    # check if this is valid move
    diff = [to_pos[0]-@pos[0], to_pos[1] - @pos[1]]
    return false unless multipled_vectors(move_diffs, n).include?(diff)
    # check if there is NO piece in new position
    return false unless @board[to_pos].nil?
    return true
  end

end
