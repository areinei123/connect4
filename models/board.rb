class Board
  NUM_COLUMNS = 10
  NUM_ROWS = 10

  def initialize(player1, player2)
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @board = Array.new(NUM_COLUMNS) { |i| Array.new(NUM_ROWS) { |i| "_"}}
    @has_move = nil
    @game_over = false
  end

  def play_game
    show_board #display the board with its changes
    column = who_moves? #player chooses a column
    update_column?(column) #update cell of chosen column or not if full
  end

  def show_board # Display the board
    @board.each do |row|
      print "| "
      row.each do |column|
        print " #{column} "
      end
      print " |\n"
    end
    print "|  1  2  3  4  5  6  7  8  9  10 |\n"
  end

  def who_moves? #Alternates between player1 and player2 
    if @has_move == nil
      @has_move = @player1 #player 1 goes first
    elsif @has_move == @player1
      @has_move = @player2 #player2 goes after player1
    elsif @has_move == @player2
      @has_move = @player1 #player1 then goes next
    end
    @has_move.choose_column #player who's turn it is selects a column
  end

  def update_column?(column) #updates a cell upon selecting a column
    if @board[0][column] != "_" #if column is full
      puts "This column is full, please pick again."
      column = @has_move.choose_column #reset column
      update_column?(column) #recurse
    else
      @board.reverse.each_with_index do |row, index| #start at base of board
        if row[column] == "_" #if blank, add a piece
          if @has_move == @player1 
            row[column] = "X"
          elsif @has_move == @player2
            row[column] = "O"
          end
          horizontal_check(row)
          vertical_check(column)
          ne_diagonal_check
          nw_diagonal_check
          if @game_over == false
            play_game
          else 
            return @game_over
          end
        end
      end
    end
  end

  def horizontal_check(row)
    count = 1
    row.each_with_index do |cell, index|
      if cell != "_"
        if cell == row[index + 1]
          count += 1
        end
        count_check(count)
      end
    end
  end

  def vertical_check(column)
    count = 1
    @board.reverse.each_with_index do |row, index|
      if @board[index][column] != "_"
        if @board[index][column] == @board[index - 1][column]
          count += 1
        end
        count_check(count)
      end
    end
  end

  # Check if a player has 4 diagonal pieces in a north-east direction
  def ne_diagonal_check
    check_board_section([-1, 1])
  end

  # Check if a player has 4 diagonal pieces in a north-west direction
  def nw_diagonal_check
    check_board_section([-1, -1])
  end

  # Determine if a section of the board has 4 consecutive pieces in a given
  # direction (with the aid of the helper methods)
  def check_board_section(position_change)
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        if @board[row_index][column_index] != "_"
          if same_piece_at_positions(diagonal_array([row_index, column_index], position_change))
            win_condition
          end
        end
      end
    end
  end

  # Determine 4 consecutive positions from a starting position in a given direction
  def diagonal_array(start_position, position_change)
    positions = [start_position]
    3.times { positions << add_positions(positions.last, position_change) }
    positions
  end

  # Add the row and col values of two positions
  def add_positions(position1, position2)
    [position1[0] + position2[0], position1[1] + position2[1]]
  end

  # Determine if all pieces in a number of positions belong to only one player
  def same_piece_at_positions(piece_positions)
    pieces = piece_positions.map { |pos| @board[pos.first][pos.last] }
    return if pieces.first == "_"
    pieces.uniq.length == 1
  end

  def count_check(count)
    if count == 4 
      @game_over = true
      show_board
      @has_move.wins
      return @game_over
    end
  end

  def win_condition
    @game_over = true
    show_board
    @has_move.wins
    return @game_over
  end
end
