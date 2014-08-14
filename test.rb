require './board'
require './piece'
require './game'
require './player'

b = Board.new()
pos = [5,2]
piece = b[pos]

#print "initial board\n"
#print b.render_board
#print "================\n"
#p piece.perform_moves([[4,3]])
##p piece.perform_moves([[4,3],[3,4]])
#print b.render_board
#p piece.perform_moves([[3,4]])
#print "================\n"
#print b.render_board
#print "================\n"
#black_piece = b[[2,5]]
#black_piece.perform_moves([[4,3]])
#black_piece.perform_moves
#print b.render_board

b0 = Board.new
p1 = Player.new("adam", :black, b0)
p2 = Player.new("eve", :white, b0)
g = Game.new(p1, p2, b0)
g.play

#p1.perform_moves([[5,2],[7,0]])
