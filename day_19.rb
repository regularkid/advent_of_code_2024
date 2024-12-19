class Towels
    def initialize(filename)
        @patterns = []
        @designs = []
        File.readlines(filename).each do |line|
            if @patterns.empty?
                @patterns = line.split(",").map { |pattern| pattern.strip }
            elsif !line.strip.empty?
                @designs.append(line.strip)
            end
        end

        @patterns = @patterns.sort_by(&:length).reverse

        #p @patterns
        #p @designs
    end

    def solve_part_1
        num_possible = 0
        @memo = Set.new
        @memo_no = Set.new
        @designs.each do |design|
            puts "Checking #{design}"
            if is_design_possible(design)
                num_possible += 1
                puts "    #{design} is possible"
            else
                puts "    #{design} is NOT possible"
            end
        end

        puts "Part 1 Answer: #{num_possible}"
    end

    def is_design_possible(design)
        if @memo.include?(design)
            return true
        end

        if @memo_no.include?(design)
            return false
        end

        if design.length == 0
            return true
        end

        @patterns.each do |pattern|
            if pattern.length > design.length
                next
            end

            is_possible = true
            pattern.chars.each_with_index do |c, index|
                if c != design[index]
                    is_possible = false
                    break
                end
            end

            if !is_possible
                next
            end

            substr = design[pattern.length..]
            #puts "Checking #{substr} for patterns #{pattern}"
            if is_design_possible(substr)
                @memo.add(substr)
                return true
            end
        end

        @memo_no.add(design)
        return false
    end
end

towels = Towels.new("day_19_input.txt")
towels.solve_part_1