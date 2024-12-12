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

    def blink_recursive(number, blinkIteration)
        if blinkIteration == 75
            return 1
        end

        memoId = "#{number},#{blinkIteration}"
        if @memo.key?(memoId)
            return @memo[memoId]
        end

        numStones = 0

        if number == 0
            numStones += blink_recursive(1, blinkIteration + 1)
        elsif number.to_s.length % 2 == 0
            s = number.to_s
            left = s[0...s.length/2]
            right = s[s.length/2..]
            numStones += blink_recursive(left.to_i, blinkIteration + 1)
            numStones += blink_recursive(right.to_i, blinkIteration + 1)
        else
            numStones += blink_recursive(number * 2024, blinkIteration + 1)
        end

        @memo[memoId] = numStones
        return numStones
    end

    def solve_part_2_recursive
        @memo = Hash.new
       
        numStones = 0
        @stones.each do |number|
            numStones += blink_recursive(number, 0)
        end
        puts "Part 2 Answer: #{numStones}"
    end
end

stones = Stones.new("day_11_input.txt")
stones.solve_part_1

stones2 = Stones.new("day_11_input.txt")
#stones2.solve_part_2
stones2.solve_part_2_recursive