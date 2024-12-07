class Equation
    attr_reader :result

    def initialize(input)
        # Format:
        # 292: 11 6 16 20
        values = input.split
        @result = values[0].delete(":").to_i
        @values = values[1..].map(&:to_i)
    end

    def isSolvableInternal(lhs, remainingValues)
        if remainingValues.empty?
            return lhs == @result
        end

        nextValue = remainingValues[0]
        return isSolvableInternal(lhs + nextValue, remainingValues[1..]) ||
               isSolvableInternal(lhs * nextValue, remainingValues[1..])
    end

    def isSolvable
        firstValue = @values[0]
        return isSolvableInternal(firstValue, @values[1..])
    end
end

sum = 0
File.readlines("day_07_input.txt").each do |line|
    eq = Equation.new(line)
    if eq.isSolvable
        sum += eq.result
    end
end

puts "Part 1 Answer: #{sum}"