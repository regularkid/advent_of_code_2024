class Equation
    attr_reader :result

    def initialize(input)
        # Format:
        # 292: 11 6 16 20
        values = input.split
        @result = values[0].delete(":").to_i
        @values = values[1..].map(&:to_i)
    end

    def combineValues(a, b)
        bNumDigits = 1
        bModified = b / 10
        while bModified > 0
            bNumDigits += 1
            bModified /= 10
        end

        return (a * (10**bNumDigits)) + b
    end

    def isSolvableInternal(lhs, remainingValues)
        if remainingValues.empty?
            return lhs == @result
        end

        nextValue = remainingValues[0]
        return isSolvableInternal(lhs + nextValue, remainingValues[1..]) ||
               isSolvableInternal(lhs * nextValue, remainingValues[1..]) ||
               (isSolvableInternal(combineValues(lhs, nextValue), remainingValues[1..]))
    end

    def isSolvable
        firstValue = @values[0]
        return isSolvableInternal(firstValue, @values[1..]) ||
               isSolvableInternal(combineValues(firstValue, @values[1]), @values[2..])
    end
end

sum = 0
File.readlines("day_07_input.txt").each do |line|
    eq = Equation.new(line)
    if eq.isSolvable
        sum += eq.result
    end
end

puts "Part 2 Answer: #{sum}"