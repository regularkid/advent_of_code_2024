def isDeltaSafe(delta, shouldBeIncreasing)
    return delta.abs >= 1 && delta.abs <= 3 && (delta > 0) == shouldBeIncreasing
end

numSafeReports = 0
File.readlines("day_02_input.txt").each do |line|
    nums = line.split.map(&:to_i)

    (0..nums.length - 1).each do |outer_index|
        nums_with_removal = nums.map(&:clone)
        nums_with_removal.delete_at(outer_index)
        isSafe = true
        shouldBeIncreasing = nums_with_removal[1] > nums_with_removal[0]
        isProblemDampenerActive = true
        
        numIncreasing = 0
        numValidDeltas = 0
        (0..nums_with_removal.length - 2).each do |index|
            if !isDeltaSafe(nums_with_removal[index + 1] - nums_with_removal[index], shouldBeIncreasing)
                isSafe = false
                break;
            end
        end

        if isSafe
            numSafeReports += 1
            break
        end
    end
end

puts("Part 1 Answer: #{numSafeReports}")