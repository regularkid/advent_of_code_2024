require 'set'

RegionInfo = Struct.new(:area, :perimeter, :corners)

class Garden
    def initialize(filename)
        @grid = []
        File.readlines(filename).each do |line|
            @grid.append(line.strip.split(""))
        end
    end

    def solve_part_1
        @visited = Set.new

        priceSum = 0
        priceSum2 = 0
        (0...@grid.length).each do |y|
            (0...@grid[y].length).each do |x|
                if !@visited.include?(get_plot_id(x, y))
                    regionInfo = RegionInfo.new(0, 0, 0)
                    visit_plot(x, y, regionInfo)
                    price = regionInfo.area * regionInfo.perimeter
                    price2 = regionInfo.area * regionInfo.corners
                    priceSum += price
                    priceSum2 += price2
                    puts "A region of #{@grid[y][x]} plants with price #{regionInfo.area} * #{regionInfo.perimeter} and #{regionInfo.corners} = #{price}"
                end
            end
        end

        puts "Total price of garden is #{priceSum} (part 1) and #{priceSum2} (part 2)"
    end

    def visit_plot(x, y, regionInfo)
        if !is_within_garden(x, y)
            return
        end

        plotId = get_plot_id(x, y)
        if @visited.include?(plotId)
            return
        end
        @visited.add(plotId)

        type = @grid[y][x]
        regionInfo.area += 1

        perimeter = 4
        if plot_contains_type(x - 1, y, type)
            perimeter -= 1
            visit_plot(x - 1, y, regionInfo)
        end

        if plot_contains_type(x + 1, y, type)
            perimeter -= 1
            visit_plot(x + 1, y, regionInfo)
        end

        if plot_contains_type(x, y - 1, type)
            perimeter -= 1
            visit_plot(x, y - 1, regionInfo)
        end

        if plot_contains_type(x, y + 1, type)
            perimeter -= 1
            visit_plot(x, y + 1, regionInfo)
        end

        regionInfo.perimeter += perimeter
        regionInfo.corners += get_corner_count(x, y, perimeter)
    end

    def plot_contains_type(x, y, type)
        if !is_within_garden(x, y)
            return false
        end

        return @grid[y][x] == type
    end

    def get_plot_id(x, y)
        return "#{x},#{y}"
    end

    def is_within_garden(x, y)
        return x >= 0 && x < @grid[0].length && y >= 0 && y < @grid.length
    end

    def get_corner_count(x, y, perimeter)
        # Single isolated plot
        if perimeter == 4
            return 4
        end

        # End cap
        if perimeter == 3
            return 2
        end

        type = @grid[y][x]
        leftMatches = plot_contains_type(x - 1, y, type)
        rightMatches = plot_contains_type(x + 1, y, type)
        topMatches = plot_contains_type(x, y - 1, type)
        bottomMatches = plot_contains_type(x, y + 1, type)

        tlMatches = plot_contains_type(x - 1, y - 1, type)
        trMatches = plot_contains_type(x + 1, y - 1, type)
        blMatches = plot_contains_type(x - 1, y + 1, type)
        brMatches = plot_contains_type(x + 1, y + 1, type)

        cornerCount = 0

        # Outside corner
        if perimeter == 2
            if (leftMatches && topMatches) ||
               (leftMatches && bottomMatches) ||
               (rightMatches && topMatches) ||
               (rightMatches && bottomMatches)
                cornerCount += 1
            end
        end

        # Inside corners
        if leftMatches && topMatches && !tlMatches
            cornerCount += 1
        end

        if leftMatches && bottomMatches && !blMatches
            cornerCount += 1
        end

        if rightMatches && topMatches && !trMatches
            cornerCount += 1
        end

        if rightMatches && bottomMatches && !brMatches
           cornerCount += 1
        end

        return cornerCount
    end
end

garden = Garden.new("day_12_input.txt")
garden.solve_part_1