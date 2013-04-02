# Sudoku solver design by Peter Norvig: http://norvig.com/sudoku.html
# This is a non-recursive refactor based on the design of Peter Norvig
# Code @ https://github.com/vaneyckt/Snippets

module SudokuHelper
  def SudokuHelper.create_starting_grid(input)
    grid = {}
    SudokuHelper.get_squares.each do |square|
      grid[square] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    end

    SudokuHelper.get_squares.each_with_index do |square, i|
      SudokuHelper.assign(grid, square, input[i].to_i) if input[i] != '.'
    end
    grid
  end

  def SudokuHelper.get_rows
    rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I']
  end

  def SudokuHelper.get_cols
    cols = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
  end

  def SudokuHelper.get_squares
    rows = SudokuHelper.get_rows
    cols = SudokuHelper.get_cols
    squares = rows.product(cols).collect { |prod| prod.join.to_sym }
  end

  def SudokuHelper.get_units(square)
    rows = SudokuHelper.get_rows
    cols = SudokuHelper.get_cols

    units = []
    units << rows.collect { |row| [row, square[1]].join.to_sym }
    units << cols.collect { |col| [square[0], col].join.to_sym }
    units << rows[(rows.index(square[0]) / 3) * 3, 3].product(cols[(cols.index(square[1]) / 3) * 3, 3]).collect { |prod| prod.join.to_sym }

    units.each { |unit| unit.delete(square) }
    units
  end

  def SudokuHelper.get_peers(square)
    peers = SudokuHelper.get_units(square).flatten.uniq
  end

  def SudokuHelper.assign(grid, square, value)
    grid[square] = [value]

    squares_to_investigate = []
    squares_to_investigate << square

    while !squares_to_investigate.empty?
      square = squares_to_investigate.pop

      # (1) if a square has only one possible value, then eliminate that value from the square's peers
      if grid[square].length == 1
        SudokuHelper.get_peers(square).each do |peer|
          if grid[peer].include?(grid[square].first)
            grid[peer].delete(grid[square].first)
            squares_to_investigate << peer if !squares_to_investigate.include?(peer)
          end
        end
      end

      # (2) if a unit has only one possible place for a value, then put the value there
      SudokuHelper.get_units(square).each do |unit|
        unit.each do |square_of_unit|
          elements_in_unit = unit.collect { |square_of_unit| grid[square_of_unit] }

          possible_values = grid[square_of_unit] - elements_in_unit.flatten.uniq
          if possible_values.length == 1
            grid[square_of_unit] = possible_values
            squares_to_investigate << square_of_unit if !squares_to_investigate.include?(square_of_unit)
          end
        end
      end
    end

    grid
  end

  def SudokuHelper.solve(grid)
    actions = []
    actions += SudokuHelper.get_next_actions(grid)

    while !actions.empty? && !SudokuHelper.is_solved(grid)
      grid = actions.pop.call
      actions += SudokuHelper.get_next_actions(grid) if !SudokuHelper.is_invalid(grid)
    end
    grid
  end

  def SudokuHelper.is_solved(grid)
    grid.all? { |square, possible_values| possible_values.length == 1 }
  end

  def SudokuHelper.is_invalid(grid)
    grid.any? { |square, possible_values| possible_values.length == 0 }
  end

  def SudokuHelper.copy_grid(grid)
    copied_grid = {}
    grid.each { |k, v| copied_grid[k] = v.dup }
    copied_grid
  end

  def SudokuHelper.get_next_actions(grid)
    actions = []
    square, possible_values = grid.select { |square, possible_values| possible_values.length > 1 }.min_by { |square, possible_values| possible_values.length }
    possible_values.each { |possible_value| actions << lambda { SudokuHelper.assign(SudokuHelper.copy_grid(grid), square, possible_value) } } if !possible_values.nil?
    actions
  end

  def SudokuHelper.print_nice(grid)
    SudokuHelper.get_squares.each_with_index do |square, i|
      print " . "                             if grid[square].length > 1
      print " #{grid[square].first} "         if grid[square].length == 1
      print "|"                               if (i % 9) == 2 || (i % 9) == 5
      print "\n"                              if (i % 9) == 8
      print " --------+---------+-------- \n" if i == 26 || i == 53
    end
  end

  def SudokuHelper.print_debug(grid)
    SudokuHelper.get_squares.each_with_index do |square, i|
      print "#{grid[square].join}".center(11)
      print "|"                                                                                                       if (i % 9) == 2 || (i % 9) == 5
      print "\n"                                                                                                      if (i % 9) == 8
      print " --------------------------------+---------------------------------+-------------------------------- \n" if i == 26 || i == 53
    end
  end
end

initial_grid = SudokuHelper.create_starting_grid("..53.....8......2..7..1.5..4....53...1..7...6..32...8..6.5....9..4....3......97..")
solved_grid = SudokuHelper.solve(initial_grid)
SudokuHelper.print_nice(solved_grid)
