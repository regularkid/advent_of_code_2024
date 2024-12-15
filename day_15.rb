Left, Right, Up, Down = 0, 1, 2, 3
Vec2 = Struct.new(:x, :y)

class WarehousePart1
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

    def solve
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

class WarehousePart2
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
                blocks = line.delete("\n").chars.map {
                    |c|
                    case c
                    when "#" then "##"
                    when "O" then "[]"
                    when "." then ".."
                    when "@" then "@."
                    end
                }
                chars = []
                blocks.each do |block|
                    block.chars.each do |c|
                        chars.append(c)
                    end
                end
                @map.append(chars)

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

    def solve
        @movements.each_with_index do |dir, index|
            case dir
            when Left then attempt_move(Vec2.new(@robotPos.x, @robotPos.y), Vec2.new(-1, 0))
            when Right then attempt_move(Vec2.new(@robotPos.x, @robotPos.y), Vec2.new(1, 0))
            when Up then attempt_move(Vec2.new(@robotPos.x, @robotPos.y), Vec2.new(0, -1))
            when Down then attempt_move(Vec2.new(@robotPos.x, @robotPos.y), Vec2.new(0, 1))
            end
        end

        puts "Part 2 Answer: #{calculate_gps_sum}"
    end

    def is_valid_position(pos)
        return pos.x >= 0 && pos.x < @map[0].length && pos.y >= 0 && pos.y < @map.length
    end

    def attempt_move(pos, delta)
        @visited = Set.new
        if can_move(pos, delta)
            @visited = Set.new
            move(pos, delta)
            @robotPos.x += delta.x
            @robotPos.y += delta.y
        end
    end

    def map_pos_id(pos)
        return (pos.y * @map.length) + pos.x
    end

    def can_move(pos, delta)
        @visited.add(map_pos_id(pos))

        if @map[pos.y][pos.x] == "."
            return true
        end

        nextPos = Vec2.new(pos.x + delta.x, pos.y + delta.y)
        if !is_valid_position(nextPos) || @map[nextPos.y][nextPos.x] == "#"
            return false
        end

        canPartnerMove = true
        if delta.y != 0
            # If pushing a box up/down, make sure it's other half can move as well
            if @map[pos.y][pos.x] == "[" && !@visited.include?(map_pos_id(Vec2.new(pos.x + 1, pos.y)))
                canPartnerMove = can_move(Vec2.new(pos.x + 1, pos.y), delta)
            elsif @map[pos.y][pos.x] == "]" && !@visited.include?(map_pos_id(Vec2.new(pos.x - 1, pos.y)))
                canPartnerMove = can_move(Vec2.new(pos.x - 1, pos.y), delta)
            end
        end

        if canPartnerMove
            return can_move(nextPos, delta)
        end

        return false
    end

    def move(pos, delta)
        @visited.add(map_pos_id(pos))

        if @map[pos.y][pos.x] == "#" || @map[pos.y][pos.x] == "."
            return
        end

        nextPos = Vec2.new(pos.x + delta.x, pos.y + delta.y)
        move(nextPos, delta)

        if delta.y != 0
            # If pushing a box up/down, make sure to move it's other half as well
            if @map[pos.y][pos.x] == "[" && !@visited.include?(map_pos_id(Vec2.new(pos.x + 1, pos.y)))
                move(Vec2.new(pos.x + 1, pos.y), delta)
            elsif @map[pos.y][pos.x] == "]" && !@visited.include?(map_pos_id(Vec2.new(pos.x - 1, pos.y)))
                move(Vec2.new(pos.x - 1, pos.y), delta)
            end
        end

        @map[nextPos.y][nextPos.x] = @map[pos.y][pos.x]
        @map[pos.y][pos.x] = "."
    end

    def calculate_gps_sum
        gpsSum = 0
        @map.each_with_index do |row, y|
            row.each_with_index do |c, x|
                if c == "["
                    gpsSum += (100 * y) + x
                end
            end
        end
        return gpsSum
    end
end

warehouse = WarehousePart2.new("day_15_input.txt")
warehouse.solve