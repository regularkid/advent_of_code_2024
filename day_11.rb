class Stones
    def initialize(filename)
        @stones = File.read(filename).split.map(&:to_i)
    end

    def blink
        index = 0
        while index < @stones.length
            number = @stones[index]
            if number == 0
                @stones[index] = 1
            elsif number.to_s.length % 2 == 0
                s = number.to_s
                left = s[0...s.length/2]
                right = s[s.length/2..]
                @stones[index] = left.to_i
                @stones.insert(index + 1, right.to_i)
                index += 1
            else
                @stones[index] *= 2024
            end
            index += 1
        end
    end

    def print
        puts @stones.to_s
    end

    def solve_part_1
        25.times do
            blink
        end
        puts "Part 1 Answer: #{@stones.length}"
    end

    def solve_part_2
        75.times do
            blink
        end
        puts "Part 2 Answer: #{@stones.length}"
    end
end

stones = Stones.new("day_11_input.txt")
stones.solve_part_1
stones.solve_part_2