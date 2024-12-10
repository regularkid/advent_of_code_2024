require 'set'

class Map
    def initialize(filename)
        @grid = []
        File.readlines(filename).each do |row|
            @grid.append(row.delete("\n").chars.map(&:to_i))
        end
    end

    def get_trailhead_score(x, y, nextHeight, trailheadEndLocations)
        if @grid[y][x] == 9
            trailheadEndLocations.add("#{x},#{y}")
            return
        end

        if x > 0 && @grid[y][x - 1] == nextHeight
            get_trailhead_score(x - 1, y, nextHeight + 1, trailheadEndLocations)
        end

        if x < @grid[y].length - 1 && @grid[y][x + 1] == nextHeight
            get_trailhead_score(x + 1, y, nextHeight + 1, trailheadEndLocations)
        end

        if y > 0 && @grid[y - 1][x] == nextHeight
            get_trailhead_score(x, y - 1, nextHeight + 1, trailheadEndLocations)
        end

        if y < @grid.length - 1 && @grid[y + 1][x] == nextHeight
            get_trailhead_score(x, y + 1, nextHeight + 1, trailheadEndLocations)
        end
    end

    def solve_part_1
        trailheadScoreSum = 0

        @grid.length.times do |y|
            @grid[y].length.times do |x|
                if @grid[y][x] != 0
                    next
                end

                trailheadEndLocations = Set.new
                get_trailhead_score(x, y, 1, trailheadEndLocations)
                trailheadScoreSum += trailheadEndLocations.length
            end
        end

        puts "Part 1 Answer: #{trailheadScoreSum}"
    end
end

map = Map.new("day_10_input.txt")
map.solve_part_1