require 'rubygems'
require 'debugger'
# SAMPLE SUDOKU 1 (HARD) 
# 0,3,0,0,0,0,0,4,5,
# 5,0,0,0,0,9,0,0,6,
# 1,0,7,0,8,0,0,0,0,
# 0,0,0,0,2,6,0,8,3,
# 0,0,0,0,0,4,5,1,0,
# 0,0,5,7,0,0,0,0,0,
# 0,0,0,0,0,0,0,2,4,
# 0,8,0,0,0,0,0,9,0,
# 0,1,3,4,0,7,0,5,0
# 

# SAMPLE SUDOKU 2 (EASY) 
# puzzle = Sudoku.new([0,0,4,7,2,0,9,0,0,0,3,9,0,0,8,0,0,5,0,0,1,5,0,6,0,0,4,0,4,0,0,1,0,5,2,0,0,2,8,0,5,0,1,7,0,0,1,6,0,3,0,0,9,0,4,0,0,9,0,1,3,0,0,1,0,0,3,0,0,8,4,0,0,0,7,0,8,5,6,0,0])

# First step is finding the gimmes. The easy solves.
# 
# For every box, every row and every column check to see if there is only one missing number.
# 
# Next go tactically
# 
# For every box, every row and every column 

# really? why not predefined
require 'matrix'
class Matrix
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

class Sudoku
  attr_accessor :puzzle

  def initialize(numbers)
    raise ArgumentError, "provide an array"    unless numbers.class.eql?(Array)
    raise ArgumentError, "81 squares required" unless numbers.length.eql?(81)

    # self.numbers = []

    # numbers.each_with_index do |number, index|
    #   self.numbers << Square.new(number, index, self)
    # end

    self.puzzle = Matrix.build(9){|r,c| numbers[r*9+c]}
  end    

  def unsolved?
    puzzle.to_a.flatten.include?(0)
  end

  def solve
    @stuck = false

    while unsolved? && !@stuck do

      puzzle.each_with_index do |num, ri, ci|
        next unless num.eql?(0)

        row = puzzle.row(ri).to_a
        col = puzzle.column(ci).to_a

        box_row_top     = (ri/3)*3
        box_row_bottom  = box_row_top+ 2 
        box_column_left    = (ci/3)*3
        box_column_right   = box_column_left + 2

        box = (box_row_top..box_row_bottom).map{|r| puzzle.row(r).to_a[box_column_left..box_column_right]}.flatten

        # difference between all possible values and current unique values
        possible = [1,2,3,4,5,6,7,8,9]-((row|col|box)-[0])

        # elimination strategy
        if possible.length.eql?(1)
          puts "Solved for row: #{ri+1} column: #{ci+1} as #{possible[0]} using elimination strategy"
          puzzle[ri,ci] = possible[0]
          draw
          next
        end

        # adjacent squares and boxes
        # --- if two adjacent squares, vertical or horizontal are known
        # --- and in the same direction in different boxes there are common solved numbers
        # ---- then a solution is possible

        # go vertical first
        if (((box_column_left..box_column_right).map{|i|i}-[ci]).map{|c| puzzle.column(c).to_a[ri]}-[0]).length.eql?(2)
          rows = ((box_row_top..box_row_bottom).map{|i|i}-[ri]).map{|r| puzzle.row(r).to_a}
          solved_in_rows = rows[0] & rows[1]
          
          if (solution = solved_in_rows & possible).length.eql?(1)
            puts "Solved for row: #{ri+1} column: #{ci+1} as #{solution[0]} using vertical squares and adjacent rows"
            puzzle[ri,ci] = solution[0]
            draw
            next
          end
        end
        
        # and then horizontal
        if (((box_row_top..box_row_bottom).map{|i|i}-[ri]).map{|r| puzzle.row(r).to_a[ci]}-[0]).length.eql?(2)
          columns = ((box_column_left..box_column_right).map{|i|i}-[ci]).map{|c| puzzle.column(c).to_a}
          solved_in_columns = columns[0] & columns[1]
          
          if (solution = solved_in_columns & possible).length.eql?(1)
            puts "Solved for row: #{ri+1} column: #{ci+1} as #{solution[0]} using horizontal squares and adjacent columns"
            puzzle[ri,ci] = solution[0]
            draw
            next
          end
        end

      end

    end

    if unsolved?
      puts "Couldn't solve!"
    else
      puts "Great success!"
    end
    self.draw
  end

  def draw
    9.times do |i|
      row = puzzle.row(i).to_a
      puts "| #{row.join(' | ')} |"
    end
  end

end

# puzzle = Sudoku.new([0,3,0,0,0,0,0,4,5,5,0,0,0,0,9,0,0,6,1,0,7,0,8,0,0,0,0,0,0,0,0,2,6,0,8,3,0,0,0,0,0,4,5,1,0,0,0,5,7,0,0,0,0,0,0,0,0,0,0,0,0,2,4,0,8,0,0,0,0,0,9,0,0,1,3,4,0,7,0,5,0])

puzzle = Sudoku.new([8,6,0,0,2,0,0,0,0,0,0,0,7,0,0,0,5,9,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,8,0,0,0,4,0,0,0,0,0,0,0,0,0,5,3,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,6,0,0,0,0,7,5,0,9,0,0,0])

puzzle.draw
puzzle.solve

