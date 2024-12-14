class Robot
    def initialize(x, y, vx, vy)
        @x, @y, @vx, @vy = x, y, vx, vy
    end

    def to_s
        "#{@x},#{@y} : #{@vx},#{@vy}"
    end

    def sim(numSeconds, spaceWidth, spaceHeight)
        @x += @vx * numSeconds
        @y += @vy * numSeconds
        @x = @x % spaceWidth
        @y = @y % spaceHeight
    end

    def get_quadrant(spaceWidth, spaceHeight)
        xMiddle = spaceWidth / 2
        yMiddle = spaceHeight / 2
        if @x < xMiddle && @y < yMiddle
            return 0
        elsif @x > xMiddle && @y < yMiddle
            return 1
        elsif @x < xMiddle && @y > yMiddle
            return 2
        elsif @x > xMiddle && @y > yMiddle
            return 3
        end

        return -1
    end
end

robots = []
File.readlines("day_14_input.txt").each do |line|
    values = line.scan(/p=(\d+),(\d+) v=(-*\d+),(-*\d+)/)
    robots.append(Robot.new(values[0][0].to_i, values[0][1].to_i, values[0][2].to_i, values[0][3].to_i))
end

quadrantCounts = [0, 0, 0, 0]
robots.each do |robot|
    robot.sim(100, 101, 103)
    quadrant = robot.get_quadrant(101, 103)
    if quadrant != -1
        quadrantCounts[quadrant] += 1
    end
end

safetyFactor = quadrantCounts[0]*quadrantCounts[1]*quadrantCounts[2]*quadrantCounts[3]
puts "Part 1 Answer: #{safetyFactor} (#{quadrantCounts.to_s})"