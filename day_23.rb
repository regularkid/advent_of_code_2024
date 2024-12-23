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
end

network = Network.new("day_23_input.txt")
network.solve_part_1