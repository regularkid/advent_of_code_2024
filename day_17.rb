class CPU
    def initialize(filename)
        lines = File.readlines(filename)
        @a = lines[0].match(/Register A: (\d+)/)[1].to_i
        @b = lines[1].match(/Register B: (\d+)/)[1].to_i
        @c = lines[2].match(/Register C: (\d+)/)[1].to_i
        @instructions = lines[4].split(" ")[1].delete("\n").split(",").map(&:to_i)
        @ip = 0
        @output = []
        puts self
    end

    def to_s
        "A[#{@a}] B[#{@b}] C[#{@c}] IP[#{@ip}] Instructions#{@instructions.to_s} Output#{@output.to_s}"
    end

    def get_combo_operand_value(operand)
        # Combo operands 0 through 3 represent literal values 0 through 3.
        # Combo operand 4 represents the value of register A.
        # Combo operand 5 represents the value of register B.
        # Combo operand 6 represents the value of register C.
        # Combo operand 7 is reserved and will not appear in valid programs.
        case operand
        when 0..3 then operand
        when 4 then @a
        when 5 then @b
        when 6 then @c
        when 7 then
            puts "Error! Invalid combo operand '7'"
            abort
        end
    end

    def step
        opcode = @instructions[@ip]
        operand = @instructions[@ip + 1]
        @ip += 2

        case opcode
        # The adv instruction (opcode 0) performs division.
        # The numerator is the value in the A register.
        # The denominator is found by raising 2 to the power of the instruction's combo operand.
        # (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
        # The result of the division operation is truncated to an integer and then written to the A register.
        when 0
            @a = @a / (2**get_combo_operand_value(operand))

        # The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand, then stores the result in register B.
        when 1
            @b = @b ^ operand

        # The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby keeping only its lowest 3 bits), then writes that value to the B register.
        when 2
            @b = get_combo_operand_value(operand) & 0x7

        # The jnz instruction (opcode 3) does nothing if the A register is 0.
        # However, if the A register is not zero, it jumps by setting the instruction pointer to the value of its literal operand;
        # if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
        when 3
            if @a != 0
                @ip = operand
            end

        # The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then stores the result in register B.
        # (For legacy reasons, this instruction reads an operand but ignores it.)
        when 4
            @b = @b ^ @c

        # The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value.
        # (If a program outputs multiple values, they are separated by commas.)
        when 5
            @output.append(get_combo_operand_value(operand) & 0x7)

        # The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is stored in the B register.
        # (The numerator is still read from the A register.)
        when 6
            @b = @a / (2**get_combo_operand_value(operand))

        # The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is stored in the C register.
        # (The numerator is still read from the A register.)
        when 7
            @c = @a / (2**get_combo_operand_value(operand))
        end
    end

    def run
        while @ip < @instructions.length
            step
        end

        puts self
    end
end

cpu = CPU.new("day_17_input.txt")
cpu.run