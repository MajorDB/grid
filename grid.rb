require 'bundler/setup'
require 'ruby2d'
require 'pry'

# Configurable CONSTANTS
BOX_SIZE = 100 
MAX_ROW = 10 
MAX_COL = 10 

# CONSTANTS
CANVAS_HEIGHT = BOX_SIZE * MAX_ROW 
CANVAS_WIDTH = BOX_SIZE * MAX_COL
CANVAS_SIZE = [CANVAS_HEIGHT, CANVAS_WIDTH]
WIDTH_SIZE = CANVAS_WIDTH / BOX_SIZE
HEIGHT_SIZE = CANVAS_HEIGHT / BOX_SIZE
TOTAL_SIZE = WIDTH_SIZE * HEIGHT_SIZE
TOTAL_BOXES = (WIDTH_SIZE * HEIGHT_SIZE) - 1
RANDOM_HEIGHT = HEIGHT_SIZE - 1
RANDOM_WIDTH = WIDTH_SIZE - 1
COLORS = ["red", "orange", "yellow", "green", "blue", "brown", "purple", "black", "white"]
DIRECTION = ["left", "right", "up", "down"]
OBJ_DIRECTION = ["left", "right", "up", "down"]
ICONS = ["alfred", "audacity", "intellij", "evernote", "plex", "vlc", "ryan100"]

# Enable DEBUG
DEBUG = false 

# Set application parameters
set title: "Gridmania"
set width: CANVAS_WIDTH, height: CANVAS_HEIGHT
set borderless: true

# Define empty 2d array
grid = Array.new(WIDTH_SIZE) { Array.new(HEIGHT_SIZE) }
obj = Array.new(WIDTH_SIZE) { Array.new(HEIGHT_SIZE) }

# Define Ruby2D wrapper method 
# TODO: Figure out why you wrote this
def grid_square(x, y, size, color)
  Square.new(x: x, y: y, size: size, z: 0, color: color)
end

# define movement
def moveobj(objgrid, obj, direction)
  case direction
    when "up"
      return if obj.y == 10
      obj.y = obj.y - 1
    when "down"
      return if obj.y == 610
      obj.y = obj.y + 1
    when "left"
      return if obj.x == 10 
      obj.x = obj.x - 1
    when "right"
      return if obj.x >= 910
      obj.x = obj.x + 1
  end
end

# define movement
def move(grid, square, direction, size)
  case direction
    when "up"
      return if (square.y / size) - 1 < 0
      puts "up row: #{(square.y / size) - 1} -- col: #{square.x / size}" if DEBUG
      grid[(square.y / size) - 1][square.x / size].color = square.color.instance_variables.map { |a| square.color.instance_variable_get a }
    when "down"
      return if (square.y / size) + 1 > RANDOM_HEIGHT 
      puts "down row: #{(square.y / size) + 1} -- col: #{square.x / size}" if DEBUG
      grid[(square.y / size) + 1][square.x / size].color = square.color.instance_variables.map { |a| square.color.instance_variable_get a }
    when "left"
      return if (square.x / size) - 1 < 0
      puts "left row: #{square.y / size} -- col: #{(square.x / size) - 1}" if DEBUG
      grid[square.y / size][(square.x / size) - 1].color = square.color.instance_variables.map { |a| square.color.instance_variable_get a }
    when "right"
      return if (square.x / size) + 1 > RANDOM_WIDTH
      puts "right row: #{square.y / size} -- col: #{(square.x / size) + 1}" if DEBUG
      grid[square.y / size][(square.x / size) + 1].color = square.color.instance_variables.map { |a| square.color.instance_variable_get a }
  end
end

# Define iterator and positional vars
i = 0
current_x = 0
current_y = 0

(0..TOTAL_BOXES).each do |i|

  column = i % WIDTH_SIZE
  row = i / WIDTH_SIZE

  current_x = column * BOX_SIZE
  current_y = row * BOX_SIZE 

  puts "row: #{row} -- column: #{column} -- x: #{current_x} -- y: #{current_y}" if DEBUG

  #grid[row][column] = grid_square(current_x, current_y, BOX_SIZE, "#{COLORS[rand(COLORS.length)]}")
  grid[row][column] = grid_square(current_x, current_y, BOX_SIZE, "#{COLORS[rand(COLORS.length)]}")
  obj[row][column] = Image.new(x: current_x + 10, y: current_y + 10, z: 1, width: 80, height: 80, path: "assets/#{ICONS[rand(ICONS.length)]}.png")
  i += 1

end

binding.pry if DEBUG

ctick = 0

update do

  until ctick >= TOTAL_BOXES do
    #grid[rand(HEIGHT_SIZE)][rand(WIDTH_SIZE)].color = "#{COLORS[rand(COLORS.length)]}" # color randomly with 2d array
    #grid[rand(grid.length)].color = "#{COLORS[rand(COLORS.length)]}" # color randomly with array
    move(grid, grid[rand(HEIGHT_SIZE)][rand(WIDTH_SIZE)], DIRECTION[rand(DIRECTION.length)], BOX_SIZE) # move randomly with 2d array
    moveobj(obj, obj[rand(HEIGHT_SIZE)][rand(WIDTH_SIZE)], OBJ_DIRECTION[rand(OBJ_DIRECTION.length)])
    ctick += 1
  end
  
  ctick = 0 

end
binding.pry if DEBUG

show
