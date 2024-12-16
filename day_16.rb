require 'algorithms'
include Containers

Right, Up, Left, Down = 0, 1, 2, 3

class Pos
    attr_accessor :x, :y

    def initialize(x, y)
        @x, @y = x, y
    end

    def ==(other)
        other.x == self.x && other.y == self.y
    end

    def to_s
        "(#{@x},#{@y})"
    end

    alias eql? ==

    def hash
        @y*1000 + @x
    end
end

class Map
    def initialize(filename)
        @dir = Right
        @grid = []
        File.readlines(filename).each do |line|
            @grid.append(line.delete("\n").split(""))
            @grid.last.each_with_index do |char, x|
                if char == "S"
                    @start = Pos.new(x, @grid.length - 1)
                elsif char == "E"
                    @end = Pos.new(x, @grid.length - 1)
                end
            end
        end
    end

    def display
        @grid.each do |row|
            row.each do |char|
                print "#{char}"
            end
            print "\n"
        end
    end

    def solve_part_1
        frontier = PriorityQueue.new
        frontier.push(@start, 0)
        came_from = Hash.new
        #came_from[@start] = nil
        cost_so_far = Hash.new
        cost_so_far[@start] = 0

        while !frontier.empty?
            current = frontier.pop

            #if current == @end then break end

            dx = 0
            dy = 0
            if came_from.key?(current)
                last = came_from[current]
                dx = current.x - last.x
                dy = current.y - last.y
            else
                @dir = Right
            end

            if dx == 1
                @dir = Right
            elsif dx == -1
                @dir = Left
            elsif dy == -1
                @dir = Up
            elsif dy == 1
                @dir = Down
            end

            get_neighbors(current).each do |neighbor|
                new_cost = cost_so_far[current] + get_cost(current, neighbor)
                if !cost_so_far.key?(neighbor) || new_cost < cost_so_far[neighbor]
                    cost_so_far[neighbor] = new_cost
                    frontier.push(neighbor, new_cost)
                    came_from[neighbor] = current
                end
            end
        end

        current = Pos.new(@end.x, @end.y)
        path = Set.new
        while current != @start 
            path.add(current)
            current = came_from[current]
        end
        path.add(@start)

        @grid.each_with_index do |row, y|
            row.each_with_index do |char, x|
                if path.include?(Pos.new(x, y))
                    print "^"
                elsif char == "."
                    print " "
                else
                    print "#{char}"
                end
            end
            print "\n"
        end

        puts "Part 1 Answer: #{cost_so_far[@end]}"
    end

    def is_valid_pos(pos)
        return pos.x >= 0 && pos.x < @grid[0].length && pos.y >= 0 && pos.y < @grid.length && @grid[pos.y][pos.x] != "#"
    end

    def get_neighbors(pos)
        neighbors = []
        left = Pos.new(pos.x - 1, pos.y)
        right = Pos.new(pos.x + 1, pos.y)
        up = Pos.new(pos.x, pos.y - 1)
        down = Pos.new(pos.x, pos.y + 1)
        if is_valid_pos(left) then neighbors.append(left) end
        if is_valid_pos(right) then neighbors.append(right) end
        if is_valid_pos(up) then neighbors.append(up) end
        if is_valid_pos(down) then neighbors.append(down) end
        return neighbors
    end

    def get_cost(from, to)
        dx = to.x - from.x
        dy = to.y - from.y

        case @dir
        when Right then
            if dx == 1
                1
            elsif dy != 0
                1001
            else
                1000000
            end
        when Left then
            if dx == -1
                1
            elsif dy != 0
                1001
            else
                1000000
            end
        when Up then
            if dy == -1
                1
            elsif dx != 0
                1001
            else
                1000000
            end
        when Down then
            if dy == 1
                1
            elsif dx != 0
                1001
            else
                1000000
            end
        end
    end
end

map = Map.new("day_16_input.txt")
map.solve_part_1