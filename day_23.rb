class Network
    def initialize(filename)
        @connections = Hash.new()
        File.readlines(filename).each do |line|
            comps = line.strip.split("-")
            add_connection(comps[0], comps[1])
        end

        #p @connections
    end

    def add_connection(comp1, comp2)
        if !@connections.key?(comp1) then @connections[comp1] = Set.new end
        if !@connections.key?(comp2) then @connections[comp2] = Set.new end
        @connections[comp1].add(comp2)
        @connections[comp2].add(comp1)
    end

    def solve_part_1
        @triples = Set.new
        @connections.each do |k, v|
            if k[0] != "t"
                next
            end

            v.each do |c1|
                v.each do |c2|
                    if c1 == c2
                        next
                    end

                    if @connections[c1].include?(c2)
                        triple = [k, c1, c2].sort
                        @triples.add(triple.to_s)
                    end
                end
            end
        end

        #p @triples
        puts "Part 1 Answer: #{@triples.length}"
    end

    def solve_part_2
        @sets = Set.new
        @connections.each do |k, v|
            v.each do |c|
                set = Set.new
                set.add(k)
                set.add(c)
                @sets.add(set)
            end
        end

        #puts "BEFORE:"
        #p @sets

        @connections.each do |k, v|
            @sets.each do |set|
                # Already part of this set?
                if set.include?(k)
                    next
                end

                # Is connected to all comps in this set?
                isConnectedToAll = true
                set.each do |c|
                    if !v.include?(c)
                        isConnectedToAll = false
                        break
                    end
                end

                # Add to this set
                if isConnectedToAll
                    set.add(k)
                end
            end
        end

        #puts "AFTER:"
        #p @sets

        longest = 0
        longest_set = nil
        @sets.each do |set|
            if set.size > longest
                longest = set.size
                longest_set = set
            end
        end

        puts "Part 2 Answer: #{longest_set.to_a.sort.join(",")}"
    end
end

network = Network.new("day_23_input.txt")
network.solve_part_1
network.solve_part_2