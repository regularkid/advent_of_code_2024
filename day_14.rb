class Robot
    def initialize(x, y, vx, vy)
        @x, @y, @vx, @vy = x, y, vx, vy
    end

    def to_s
        "#{@x},#{@y} : #{@vx},#{@vy}"
    end

    def x
        @x
    end

    def y
        @y
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

def display_robots(robots, spaceWidth, spaceHeight, file)
    (0...spaceHeight).each do |y|
        s = ""
        (0...spaceWidth).each do |x|
            robotCount = 0
            robots.each do |robot|
                if robot.x == x && robot.y == y
                    robotCount += 1
                end
            end

            if robotCount > 0
                s += robotCount.to_s
            else
                s += "."
            end
        end
        #puts s
        file.write(s)
        file.write("\n")
    end
end

robots = []
File.readlines("day_14_input.txt").each do |line|
    values = line.scan(/p=(\d+),(\d+) v=(-*\d+),(-*\d+)/)
    robots.append(Robot.new(values[0][0].to_i, values[0][1].to_i, values[0][2].to_i, values[0][3].to_i))
end

spaceWidth = 101
spaceHeight = 103

File.open("day_14_output.txt", 'w') do |file|
    (1..10000).each do |second|
        robots.each do |robot|
            robot.sim(1, spaceWidth, spaceHeight)
        end

        #puts ""
        #puts "Seconds: #{second}"

        # Noticed a pattern of clumped robots every 103 & 101 seconds starting from specific values
        # so just printing those with the assumption that they will eventually be a tree
        if (second - 76) % 103 == 0 ||
           (second - 14) % 101 == 0
            file.write("\n")
            file.write("Seconds: #{second}\n")
            display_robots(robots, spaceWidth, spaceHeight, file)
        end
    end
end

quadrantCounts = [0, 0, 0, 0]
robots.each do |robot|
    quadrant = robot.get_quadrant(spaceWidth, spaceHeight)
    if quadrant != -1
        quadrantCounts[quadrant] += 1
    end
end
safetyFactor = quadrantCounts[0]*quadrantCounts[1]*quadrantCounts[2]*quadrantCounts[3]
puts "Part 1 Answer: #{safetyFactor} (#{quadrantCounts.to_s})"