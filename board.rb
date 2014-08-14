require "./piece"
class Board
  LENGTH = 8
  attr_accessor :grids
  
  def self.generate_test_board
    board = Board.new(true) 
    p board
    test_positions_white = [[2, 4], [4,2], [5, 5]]
    test_positions_black = [[3,3], [4,6], [6,4]]
    test_positions_white.each do |pos|
      board[pos] = Piece.new(pos, :white, self)
    end
    test_positions_black.each do |pos|
      board[pos] = Piece.new(pos, :black, self)
    end
    board
  end
  
  def initialize(test_option = false)
    generate_board
  end

  def [](pos)
    row, col = pos
    @grids[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grids[row][col] = piece
  end

  def render_board
    @grids.map do |row|
      row.map do |grid|
        render_grid(grid)  
      end.join("")
    end.join("\n") +"\n"    
  end
  
  def render_grid(grid)
    return " " if grid.nil? 
    return grid.render if grid.is_a?(Piece)
  end
  
  #private
  def generate_board
    # set nil in empty grid
    @grids = Array.new(LENGTH){Array.new(LENGTH, nil)}
    
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

