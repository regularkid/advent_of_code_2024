require 'set'

RegionInfo = Struct.new(:area, :permiter)

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
        (0...@grid.length).each do |y|
            (0...@grid[y].length).each do |x|
                if !@visited.include?(get_plot_id(x, y))
                    regionInfo = RegionInfo.new(0, 0)
                    visit_plot(x, y, regionInfo)
                    price = regionInfo.area * regionInfo.permiter
                    priceSum += price
                    puts "A region of #{@grid[y][x]} plants with price #{regionInfo.area} * #{regionInfo.permiter} = #{price}"
                end
            end
        end

        puts "Total price of garden is #{priceSum}"
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

        permiter = 4
        if plot_contains_type(x - 1, y, type)
            permiter -= 1
            visit_plot(x - 1, y, regionInfo)
        end

        if plot_contains_type(x + 1, y, type)
            permiter -= 1
            visit_plot(x + 1, y, regionInfo)
        end

        if plot_contains_type(x, y - 1, type)
            permiter -= 1
            visit_plot(x, y - 1, regionInfo)
        end

        if plot_contains_type(x, y + 1, type)
            permiter -= 1
            visit_plot(x, y + 1, regionInfo)
        end

        regionInfo.permiter += permiter
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
end

garden = Garden.new("day_12_input.txt")
garden.solve_part_1