class Player
  attr_accessor :stdin

  def initialize(name)
    @name = name
  end

  def choose_column
    puts "#{@name}, choose a column (1-10) and press enter"
    return gets.strip.to_i - 1
  end

  def wins
    puts "#{@name} WINS!"
  end
end