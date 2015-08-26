require 'pry'
require_relative 'models/board.rb'
require_relative 'models/player.rb'


# Players enter their names
puts "Player 1, please enter your name."
player1 = gets.chomp

puts "Player 2, please enter your name."
player2 = gets.chomp

# Theatrically start game
puts "This game is between " + player1 + " and " + player2 + "! FIGHT!"

# call game method
game = Board.new(player1, player2)
game.play_game

