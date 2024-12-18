require "algorithms"
include Containers

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
        @y*71 + x
    end
end

class MemorySpace
    def initialize(filename, gridSize, numBytesToRead)
        @grid = []
        @next_corruptions = []
        gridSize.times { @grid.append([]) }
        @grid.each do |row|
            gridSize.times { row.append(0) }
        end

        File.readlines(filename).each_with_index do |byte, index|
            values = byte.delete("\n").split(",").map(&:to_i)
            x = values[0]
            y = values[1]

            if index < numBytesToRead
                @grid[y][x] = 1
            else
                @next_corruptions.append(Pos.new(x, y))
            end
        end
    end

    def solve_part_1
        frontier = PriorityQueue.new
        came_from = Hash.new
        cost_so_far = Hash.new

        frontier.push(Pos.new(0, 0), 0)
        cost_so_far[Pos.new(0, 0)] = 0

        while !frontier.empty?
            current = frontier.pop

            get_neighbors(current).each do |neighbor|
                new_cost = cost_so_far[current] + 1
                if !cost_so_far.key?(neighbor) || new_cost < cost_so_far[neighbor]
                    frontier.push(neighbor, new_cost)
                    came_from[neighbor] = current
                    cost_so_far[neighbor] = new_cost
                end
            end
        end

        current = Pos.new(70, 70)
        path = Set.new
        while current != Pos.new(0, 0)
            path.add(current)
            current = came_from[current]
        end
        path.add(Pos.new(0, 0))

        @grid.each_with_index do |row, y|
            row.each_with_index do |value, x|
                if value == 1
                    print "#"
                elsif path.include?(Pos.new(x, y))
                    print "O"
                else
                    print "."
                end
            end
            print "\n"
        end

        final_cost = cost_so_far[Pos.new(70, 70)]
        puts "Part 1 Answer: #{final_cost}"
    end

    def solve_part_2(next_corruptions_to_add)
        next_corruptions_to_add.times do |num|
            next_corruption = @next_corruptions.shift
            @grid[next_corruption.y][next_corruption.x] = 1
        end

        while !@next_corruptions.empty?
            next_corruption = @next_corruptions.shift
            @grid[next_corruption.y][next_corruption.x] = 1

            frontier = PriorityQueue.new
            came_from = Hash.new
            cost_so_far = Hash.new

            frontier.push(Pos.new(0, 0), 0)
            cost_so_far[Pos.new(0, 0)] = 0

            while !frontier.empty?
                current = frontier.pop

                get_neighbors(current).each do |neighbor|
                    new_cost = cost_so_far[current] + 1
                    if !cost_so_far.key?(neighbor) || new_cost < cost_so_far[neighbor]
                        frontier.push(neighbor, new_cost)
                        came_from[neighbor] = current
                        cost_so_far[neighbor] = new_cost
                    end
                end
            end

            has_path = cost_so_far.key?(Pos.new(70, 70))
            if !has_path
                puts "No path once corruption #{next_corruption.x},#{next_corruption.y} is placed"
                break
            end
        end
    end

    def is_valid_pos(pos)
        return pos.x >= 0 && pos.x < @grid[0].length && pos.y >= 0 && pos.y < @grid.length && @grid[pos.y][pos.x] != 1
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
end

memorySpace = MemorySpace.new("day_18_input.txt", 71, 1024)
memorySpace.solve_part_2(1400)