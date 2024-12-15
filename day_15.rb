Left, Right, Up, Down = 0, 1, 2, 3
Vec2 = Struct.new(:x, :y)

class Warehouse
    def initialize(filename)
        @map = []
        @movements = []
        @robotPos = Vec2.new(0, 0)

        isReadingMap = true
        File.readlines(filename).each do |line|
            if line == "\n"
                isReadingMap = false
                next
            end

            if isReadingMap
                @map.append(line.delete("\n").chars)
                @map.last.each_with_index do |c, index|
                    if c == "@"
                        @robotPos.x = index
                        @robotPos.y = @map.length - 1
                    end
                end
            else
                charToDir = {"<" => Left, ">" => Right, "^" => Up, "v" => Down}
                line.chars.each do |c|
                    if charToDir.key?(c)
                        @movements.append(charToDir[c])
                    end
                end
            end
        end
    end

    def display_map
        @map.each do |row|
            row.each do |c|
                print "#{c}"
            end
            print "\n"
        end
    end

    def solve_part_1
        @movements.each_with_index do |dir, index|
            case dir
            when Left then shift(Vec2.new(-1, 0))
            when Right then shift(Vec2.new(1, 0))
            when Up then shift(Vec2.new(0, -1))
            when Down then shift(Vec2.new(0, 1))
            end

            #puts "\nStep #{index + 1}"
            #display_map
        end

        puts "Part 1 Answer: #{calculate_gps_sum}"
    end

    def is_valid_position(pos)
        return pos.x >= 0 && pos.x < @map[0].length && pos.y >= 0 && pos.y < @map.length
    end

    def shift(delta)
        curPos = Vec2.new(@robotPos.x, @robotPos.y)
        while is_valid_position(curPos) && @map[curPos.y][curPos.x] != "." && @map[curPos.y][curPos.x] != "#"
            curPos.x += delta.x
            curPos.y += delta.y
        end

        # Found empty position?
        if is_valid_position(curPos) && @map[curPos.y][curPos.x] == "."
            while curPos.x != @robotPos.x || curPos.y != @robotPos.y
                @map[curPos.y][curPos.x] = @map[curPos.y - delta.y][curPos.x - delta.x]
                curPos.x -= delta.x
                curPos.y -= delta.y
            end
            @map[@robotPos.y][@robotPos.x] = "."
            @robotPos.x += delta.x
            @robotPos.y += delta.y
        end
    end

    def calculate_gps_sum
        gpsSum = 0
        @map.each_with_index do |row, y|
            row.each_with_index do |c, x|
                if c == "O"
                    gpsSum += (100 * y) + x
                end
            end
        end
        return gpsSum
    end
end

warehouse = Warehouse.new("day_15_input.txt")
warehouse.solve_part_1