GateInput = Struct.new(:a, :b, :out, :operator)

class Gates
    def initialize(filename)
        @outputs = Hash.new
        inputs = []
        File.readlines(filename).each do |line|
            if line.include?(":")
                match = line.match(/([\w\d]+):\s*(1|0)/)
                @outputs[match[1]] = match[2].to_i
            elsif line.include?("->")
                match = line.match(/([\w\d]+)\s*([\w\d]+)\s*([\w\d]+)\s*->\s*([\w\d]+)/)
                inputs.append(GateInput.new(match[1], match[3], match[4], match[2]))
            end
        end

        # Convert inputs into outputs
        while !inputs.empty? do
            input_to_convert_index = -1
            inputs.each_with_index do |input, index|
                if !@outputs.key?(input.a) || !@outputs.key?(input.b)
                    next
                end

                input_to_convert_index = index
                break
            end

            if input_to_convert_index == -1
                puts "Error: Couldn't find input to convert!"
                break
            end

            input = inputs[input_to_convert_index]
            case input.operator
            when "AND"
                @outputs[input.out] = (@outputs[input.a] == 1) && (@outputs[input.b] == 1) ? 1 : 0
            when "OR"
                @outputs[input.out] = (@outputs[input.a] == 1) || (@outputs[input.b] == 1) ? 1 : 0
            when "XOR"
                @outputs[input.out] = (@outputs[input.a] != @outputs[input.b]) ? 1 : 0
            end
            inputs.delete_at(input_to_convert_index)
        end

        #p @outputs.to_a.sort
    end

    def solve_part_1
        final_output = 0
        @outputs.each do |k, v|
            if k[0] != "z" || v == 0
                next
            end

            bit_place = k.delete("z").to_i
            final_output |= (1 << bit_place)
        end
        puts "Part 1 Answer: #{final_output}"
    end
end

gates = Gates.new("day_24_input.txt")
gates.solve_part_1