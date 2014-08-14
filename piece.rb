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
  def perform_slide(to_pos)
    return false unless check_move(to_pos) 
    
    current_pos = @pos
    @pos = to_pos
    @board[current_pos] = nil
    @board[@pos] = self
  end

  def perform_jump(to_pos)
    return false unless check_move(to_pos) 
    
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
  end

  # move sequence [[a,b], [c,d]...]
  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      raise InvalidMoveError.new("can not slide here") perform_slide(move_sequence[0])
    end
  end

  def maybe_promote

  end
  
  def render
    return "B" if @color == :black
    return "W" if @color == :white
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
  
  def check_move(to_pos)
    # check if new position is in boudary
    return false unless in_boudary?(to_pos)
    
    # check if this is valid move
    diff = [to_pos[0]-@pos[0], to_pos[1] - @pos[1]]
    return false unless multipled_vectors(move_diffs, 2).include?(diff)
    # check if there is NO piece in new position
    return false unless @board[to_pos].nil?
    return true
  end 
  

end