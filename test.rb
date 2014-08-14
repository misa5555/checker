require './board'
require './piece'


b = Board.new()
pos = [5,2]
piece = b[pos]

print b.render_board
print "================\n"
piece.perform_slide([4,3])
print b.render_board
piece.perform_slide([3,4])
print "================\n"
print b.render_board
print "================\n"
black_piece = b[[2,5]]
black_piece.perform_jump([4,3])

print b.render_board
