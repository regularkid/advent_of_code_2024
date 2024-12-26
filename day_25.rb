class Schematics
    def initialize(filename)
        @locks = []
        @keys = []

        lineIdx = 0
        curSchematic = []
        isLock = false
        File.readlines(filename).each do |line|
            if line.strip.empty?
                next
            end

            if lineIdx == 0
                isLock = line.chars[0] == "#"
                curSchematic = [-1, -1, -1, -1, -1]
            end

            line.strip.chars.each_with_index do |c, index|
                if c == "#"
                    curSchematic[index] += 1
                end
            end

            lineIdx += 1
            if lineIdx == 7
                if isLock
                    @locks.append(curSchematic)
                else
                    @keys.append(curSchematic)
                end

                lineIdx = 0
            end
        end

        #p @locks
        #p @keys
    end

    def solve_part_1
        total_without_overlap = 0

        @locks.each do |lock|
            @keys.each do |key|
                hasOverlap = false
                (0...5).each do |index|
                    if lock[index] + key[index] >= 6
                        hasOverlap = true
                        break
                    end
                end

                if !hasOverlap
                    total_without_overlap += 1
                end
            end
        end

        puts "Part 1 Answer: #{total_without_overlap}"
    end
end

s = Schematics.new("day_25_input.txt")
s.solve_part_1