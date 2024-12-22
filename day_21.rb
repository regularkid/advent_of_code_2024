# DOES NOT SOLVE :(

KeypadPos = Struct.new(:x, :y)

class Robot
    def initialize(is_numeric)
        @is_numeric = is_numeric
        if is_numeric
            @keyPos = {"7" => KeypadPos.new(0, 0), "8" => KeypadPos.new(1, 0), "9" => KeypadPos.new(2, 0),
                       "4" => KeypadPos.new(0, 1), "5" => KeypadPos.new(1, 1), "6" => KeypadPos.new(2, 1),
                       "1" => KeypadPos.new(0, 2), "2" => KeypadPos.new(1, 2), "3" => KeypadPos.new(2, 2),
                                                   "0" => KeypadPos.new(1, 3), "A" => KeypadPos.new(2, 3)}
        else
            @keyPos = {                            "^" => KeypadPos.new(1, 0), "A" => KeypadPos.new(2, 0),
                       "<" => KeypadPos.new(0, 1), "v" => KeypadPos.new(1, 1), ">" => KeypadPos.new(2, 1)}
        end

        @keyToKeyCommands = Hash.new
        @keyPos.each do |from, fromPos|
            @keyToKeyCommands[from] = Hash.new
            @keyPos.each do |to, toPos|
                xDelta = toPos.x - fromPos.x
                yDelta = toPos.y - fromPos.y
                hDir = xDelta > 0 ? ">" : "<"
                vDir = yDelta > 0 ? "v" : "^"
                @keyToKeyCommands[from][to] = []
                @keyToKeyCommands[from][to].append((hDir*xDelta.abs) + (vDir*yDelta.abs))
                @keyToKeyCommands[from][to].append((vDir*yDelta.abs) + (hDir*xDelta.abs))
            end
        end
    end

    def get_key_to_key_commands(from, to)
        index = 0
        if index == 0 && @is_numeric && @keyPos[from].y == 3 && @keyPos[to].x = 0
            index = 1
        end

        if index == 0 && !@is_numeric && @keyPos[from].y == 0 && @keyPos[to].x = 0
            index = 1
        end

        return @keyToKeyCommands[from][to][index]
    end

    def get_sequence_commands(sequence)
        commands = ""
        cur = "A"
        sequence.chars.each do |key|
            commands += get_key_to_key_commands(cur, key)
            commands += "A"
            cur = key
        end
        commands
    end
end

class RobotChain
    def initialize(filename, num_directional_robots)
        @sequences = []
        File.readlines(filename).each do |line|
            @sequences.append(line.strip)
        end

        @robots = []
        @robots.append(Robot.new(true))
        num_directional_robots.times do
            @robots.append(Robot.new(false))
        end
    end

    def get_sequence_commands(sequence)
        commands = ""
        @robots.each do |robot|
            commands = robot.get_sequence_commands(commands.empty? ? sequence : commands)
        end
        return commands
    end

    def solve_part_1
        complexitySum = 0
        @sequences.each do |sequence|
            commands = get_sequence_commands(sequence)
            numeric_part = sequence.delete("A").to_i
            complexity = commands.length * numeric_part
            complexitySum += complexity
            puts "#{sequence}: #{commands} (#{commands.length} x #{numeric_part} = #{complexity})"
        end

        puts "Part 1 Answer: #{complexitySum}"
    end
end

robot_chain = RobotChain.new("day_21_input.txt", 2)
robot_chain.solve_part_1