require 'set'

Antenna = Struct.new(:x, :y)
antennasByFreq = Hash.new()
gridWidth = 0
gridHeight = 0

File.readlines("day_08_input.txt").each_with_index do |row, y|
    cells = row.delete("\n").chars
    gridWidth = [gridWidth, cells.length].max
    gridHeight = [gridHeight, y + 1].max

    cells.each_with_index do |cell, x|
        if cell == "."
            next
        end

        if !antennasByFreq.key?(cell)
            antennasByFreq[cell] = []
        end
        antennasByFreq[cell].append(Antenna.new(x, y))
    end
end

antinodes = Set.new
antennasByFreq.each do |antenna, locations|
    locations.each_with_index do |locationA, indexA|
        locations.each_with_index do |locationB, indexB|
            if indexA == indexB
                next
            end

            dx = locationB.x - locationA.x
            dy = locationB.y - locationA.y
            xAntinode = locationA.x + dx*2
            yAntinode = locationA.y + dy*2
            if xAntinode >= 0 && xAntinode < gridWidth && yAntinode >= 0 && yAntinode < gridHeight
                antinodes.add("#{xAntinode},#{yAntinode}")
            end
        end
    end
end

puts "Part 1 Answer: #{antinodes.length}"