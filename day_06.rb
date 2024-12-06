require 'set'

grid = []
x = 0
y = 0
File.readlines("day_06_input.txt").each do |line|
    grid.append([])
    line.split("").each_with_index do |char, index|
        case char
        when "\n"
            next
        when "^"
            x = index
            y = grid.length - 1
        end
        grid.last.append(char)
    end
end

UP, RIGHT, DOWN, LEFT = 0, 1, 2, 3
dir = UP
visited = Set.new
while true
    visited.add("#{x},#{y}")
    xNext = x
    yNext = y
    
    case dir
    when UP
        yNext = y - 1
    when RIGHT
        xNext = x + 1
    when DOWN
        yNext = y + 1
    when LEFT
        xNext = x - 1
    end

    if xNext < 0 || xNext >= grid.first.length || yNext < 0 || yNext >= grid.length
        break
    end

    if grid[yNext][xNext] == "#"
        dir = (dir + 1) % 4
        next
    end

    x = xNext
    y = yNext
end

puts "Part 1 Answer: #{visited.length}"