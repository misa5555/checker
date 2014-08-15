require "./piece"
class Board
  LENGTH = 8
  attr_accessor :grids
  
  def generate_test_board
    board = Board.new(true) 
    test_positions_white = [[4,3], [6,1]] 
    test_positions_black = [[3,4]]
    
    test_positions_white.each do |pos|
      board[pos] = Piece.new(pos, :white, self)
    end
    test_positions_black.each do |pos|
      board[pos] = Piece.new(pos, :black, self)
    end
    board
  end
  
  def initialize(test_option = false)
    @grids = Array.new(LENGTH){Array.new(LENGTH, nil)}
    unless test_option
      generate_board
    else
      generate_test_board
    end
  end

  def [](pos)
    row, col = pos
    piece = @grids[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grids[row][col] = piece
  end

  def won?
    grids_tmp = @grids.flatten.compact
    if grids_tmp.none?{|grid| grid.color == :white} || grids_tmp.none?{|grid|grid.color == :black} 
      return true
    end
    return false
  end  
  
  
  def render_board
#    " 0 1 2 3 4 5 6 7\n"+
#    @grids.map do |row|
#      " "+row.map do |grid|
#        render_grid(grid)  
#      end.join(" ") 
#    end.join("\n") +"\n"    
  
    print "  0 1 2 3 4 5 6 7\n"
    @grids.each_with_index do |row, i|
      print i.to_s+" "
      row.each do |grid|
        print render_grid(grid) + " "
      end
      print "\n"
    end
  end
  
  def render_grid(grid)
    return "-" if grid.nil? 
    return grid.render if grid.is_a?(Piece)
  end

  def dup
    dup_board = Board.new 
    @grids.each_with_index do |row, x|
      row.each_with_index do |piece, y|
        pos = [x, y]
        unless self[pos].nil?
          dup_board[pos] = piece.dup(dup_board) 
        else
          dup_board[pos] = nil
        end
      end
    end
    dup_board
  end

  #private
  def generate_board
    # set nil in empty grid
    
    piece_sets = [[:black, initial_black_positions], [:white, initial_white_positions]]
    piece_sets.each do |set|
      set[1].each do |pos|
        row, col = pos
        @grids[row][col] = Piece.new(pos, set[0], self)
      end
    end
  end

  def initial_black_positions
    base = [[0,1], [0,3], [0,5], [0, 7]]
    black_pos = []
    base.each do |elem|
      black_pos << [elem[0]+1, elem[1]-1]  
      black_pos << [elem[0]+2, elem[1]]
    end
    base + black_pos 
  end

  def initial_white_positions
    base = [7, 0], [7, 2], [7, 4], [7, 6]
    white_pos = []
    base.each do |elem|
      white_pos << [elem[0]-1, elem[1]+1]
      white_pos << [elem[0]-2, elem[1]]
    end
    base + white_pos
  end
end
