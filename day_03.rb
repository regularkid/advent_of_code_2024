# 1-liner for part 1
puts File.read("day_03_input.txt").scan(/mul\((\d{1,3}),(\d{1,3})\)/).each.reduce(0) {|total, nums| total + nums[0].to_i * nums[1].to_i}

# Part 2
total = 0
isMulActive = true
File.read("day_03_input.txt").scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/).each do |instruction|
    case instruction
    when "do()"
        isMulActive = true
    when "don't()"
        isMulActive = false
    else
        if isMulActive
            nums = instruction.scan(/\d{1,3}/)
            total += nums[0].to_i * nums[1].to_i
        end
    end
end
puts total