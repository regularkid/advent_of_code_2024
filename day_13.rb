class Machine
    def initialize(ax, ay, bx, by, px, py)
        @ax, @ay, @bx, @by, @px, @py = ax, ay, bx, by, px, py
    end

    def to_s
        "A(#{@ax},#{@ay}), B(#{@bx},#{@by}), P(#{@px},#{@py})"
    end

    def solve
        # Brute force
        # minTokens = 0
        # minA = 0
        # minB = 0
        # (0..100).each do |a|
        #     (0..100).each do |b|
        #         if (a*@ax + b*@bx == @px) && (a*@ay + b*@by == @py)
        #             tokens = a*3 + b
        #             if minTokens == 0 || tokens < minTokens
        #                 minTokens = tokens
        #                 minA = a
        #                 minB = b
        #             end
        #         end
        #     end
        # end
        # puts "#{to_s} = A:#{minA}, B:#{minB} = #{minTokens}"
        # return minTokens

        # Solve system of equations using substitution
        #puts to_s
        aNum = (@py * @bx) - (@px * @by)
        aDen = (@ay * @bx) - (@ax * @by)
        #puts "a: #{aNum} / #{aDen}"
        if aNum % aDen != 0
            return 0
        end
        a = aNum / aDen
        #puts "a: #{a}"

        bNum = @px - (@ax * a)
        #puts "b: #{bNum} / #{@bx}"
        if bNum % @bx != 0
            return 0
        end
        b = bNum / @bx
        #puts "b: #{b}"

        tokens = a*3 + b
        #puts "#{to_s} = A:#{a}, B:#{b} = #{tokens}"

        return tokens
    end
end

readState = 0
ax, ay, bx, by = 0, 0, 0, 0
machines = []
File.readlines("day_13_input.txt").each do |line|
    case readState
    when 0 then
        values = line.scan(/Button A: X\+(\d+), Y\+(\d+)/)[0].map(&:to_i)
        ax, ay = values[0], values[1]
        readState += 1
    when 1 then
        values = line.scan(/Button B: X\+(\d+), Y\+(\d+)/)[0].map(&:to_i)
        bx, by = values[0], values[1]
        readState += 1
    when 2 then
        values = line.scan(/Prize: X=(\d+), Y=(\d+)/)[0].map(&:to_i)
        px, py = values[0] + 10000000000000, values[1] + 10000000000000
        machines.append(Machine.new(ax, ay, bx, by, px, py))
        readState += 1
    else
        readState = 0
    end
end

minTokensSum = 0
machines.each do |machine|
    minTokensSum += machine.solve
end

puts "Part 1 Answer: #{minTokensSum}"