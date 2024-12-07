require 'set'

UP, RIGHT, DOWN, LEFT = 0, 1, 2, 3

class Grid
    def initFromFile(filename)
        @grid = []
        @xStart = 0
        @yStart = 0
        
        File.readlines(filename).each do |line|
            @grid.append([])
            line.split("").each_with_index do |char, index|
                case char
                when "\n"
                    next
                when "^"
                    @xStart = index
                    @yStart = @grid.length - 1
                end
                @grid.last.append(char)
            end
        end
    end

    def solvePart1
        x = @xStart
        y = @yStart
        dir = UP
        visited = Set.new
        while true
            cell = "#{x},#{y}"
            visited.add(cell)
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

            if xNext < 0 || xNext >= @grid.first.length || yNext < 0 || yNext >= @grid.length
                break
            end

            if @grid[yNext][xNext] == "#"
                dir = (dir + 1) % 4
                next
            end

            x = xNext
            y = yNext
        end

        puts "Part 1 Answer: #{visited.length}"
    end

    def checkForObstructionLoop(xObstruction, yObstruction)
        if @grid[yObstruction][xObstruction] != "."
            return false
        end

        @grid[yObstruction][xObstruction] = "#"

        x = @xStart
        y = @yStart
        dir = UP
        visited = Set.new
        isLoop = false
        while true
            cell = "#{x},#{y},#{dir}"
            
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

            if xNext < 0 || xNext >= @grid.first.length || yNext < 0 || yNext >= @grid.length
                break
            end

            if @grid[yNext][xNext] == "#"
                dir = (dir + 1) % 4

                if visited.include?(cell)
                    isLoop = true
                    break
                end
    
                visited.add(cell)
                next
            end

            x = xNext
            y = yNext
        end

        @grid[yObstruction][xObstruction] = "."
        return isLoop
    end

    def solvePart2
        numLoops = 0
        (0...@grid.length).each do |y|
            (0...@grid[y].length).each do |x|
                if checkForObstructionLoop(x, y)
                    numLoops += 1
                end
            end
        end

        puts "Part 2 Answer: #{numLoops}"
    end
end

grid = Grid.new
grid.initFromFile("day_06_input.txt")
grid.solvePart1
grid.solvePart2