class Pos
    attr_accessor :x, :y

    def initialize(x, y)
        @x, @y = x, y
    end

    def ==(other)
        if other == nil
            return false
        else
            other.x == self.x && other.y == self.y
        end
    end

    def to_s
        "(#{@x},#{@y})"
    end

    alias eql? ==

    def hash
        @y*1000 + x
    end
end

class RaceTrack
    def initialize(filename)
        @grid = []
        File.readlines(filename).each_with_index do |line, y|
            @grid.append(line.strip.chars)
            start_index = line.chars.index("S")
            if start_index
                @start = Pos.new(start_index, y)
            end

            end_index = line.chars.index("E")
            if end_index
                @end = Pos.new(end_index, y)
            end
        end
    end

    def solve_part_1(max_cheat_distance)
        cur = Pos.new(@start.x, @start.y)
        time_at = Hash.new
        time_at[cur] = 0
        visited = Set.new
        visited.add(cur)
        total_cost = 0
        while cur != @end
            cur = get_next_node(cur, visited)

            total_cost += 1
            time_at[cur] = total_cost
            visited.add(cur)
        end

        cur = Pos.new(@start.x, @start.y)
        cheat_time_saved = Hash.new
        visited = Set.new
        visited.add(cur)
        add_cheat_nodes(cur, max_cheat_distance, time_at, cheat_time_saved)
        while cur != @end
            cur = get_next_node(cur, visited)
            visited.add(cur)
            add_cheat_nodes(cur, max_cheat_distance, time_at, cheat_time_saved)
        end

        cheat_time_counts = Hash.new
        cheat_time_saved.each do |pos, time_saved_list|
            time_saved_list.each do |time_saved|
                if !cheat_time_counts.key?(time_saved)
                    cheat_time_counts[time_saved] = 0
                end
                cheat_time_counts[time_saved] += 1
            end
        end
        
        cheats_saving_at_least_100 = 0
        cheat_time_counts.each do |time_saved, count|
            if time_saved >= 100
                cheats_saving_at_least_100 += count
            end
        end

        puts "Total time: #{time_at[@end]}"
        puts "Cheats saving at least 100 picoseconds: #{cheats_saving_at_least_100}"
    end

    def get_next_node(cur, visited)
        left = Pos.new(cur.x - 1, cur.y)
        right = Pos.new(cur.x + 1, cur.y)
        up = Pos.new(cur.x, cur.y - 1)
        down = Pos.new(cur.x, cur.y + 1)
        if !visited.include?(left) && is_node_walkable(left)
            return left
        elsif !visited.include?(right) && is_node_walkable(right)
            return right
        elsif !visited.include?(up) && is_node_walkable(up)
            return up
        elsif !visited.include?(down) && is_node_walkable(down)
            return down
        end
    end

    def is_node_valid(node)
        return node.x >= 0 && node.x < @grid[0].length && node.y >= 0 && node.y < @grid.length
    end

    def is_node_walkable(node)
        return is_node_valid(node) && (@grid[node.y][node.x] == "." || @grid[node.y][node.x] == "E")
    end

    def is_node_wall(node)
        return is_node_valid(node) && @grid[node.y][node.x] == "#"
    end

    def add_cheat_nodes(cur, max_cheat_distance, time_at, cheat_time_saved)
        cheat_time_saved[cur] = []
        (-max_cheat_distance..max_cheat_distance).each do |x|
            (-max_cheat_distance..max_cheat_distance).each do |y|
                if (x + y).abs != max_cheat_distance
                    next
                end

                cheat_node = Pos.new(cur.x + x, cur.y + y)
                if cheat_node.x == cur.x && cheat_node.y == cur.y
                    next
                end
                
                if !time_at.key?(cheat_node)
                    next
                end

                if is_node_walkable(cheat_node) && time_at[cheat_node] > (time_at[cur] + max_cheat_distance)
                    cheat_time_saved[cur].append(time_at[cheat_node] - time_at[cur] - max_cheat_distance)
                end
            end
        end
    end
end

raceTrack = RaceTrack.new("day_20_input.txt")
raceTrack.solve_part_1(2)