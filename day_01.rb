# Parse input
leftList = []
rightList = []
File.readlines("day_01_input.txt").each do |line|
    nums = line.split
    leftList.push(nums[0])
    rightList.push(nums[1])
end

# Sort in place ('!' is convention for 'modifies variable rather than returning a copy')
leftList.sort!
rightList.sort!

# Calculate absolute delta between each pair of values from the 2 lists
totalDelta = 0
leftList.each_with_index do |num, index|
    totalDelta += (Integer(num) - Integer(rightList[index])).abs
end

puts "Part 1 Answer: #{totalDelta}"

# Count occurrence of each number in 2nd/right list
similarityScore = 0
rightListCounts = Hash.new(0)
rightList.each { |num| rightListCounts[num] += 1 }

# Add up {left list value} * {num occurrences of that value in 2nd/right list}
leftList.each { |num| similarityScore += Integer(num) * rightListCounts[num]}

puts "Part 2 Answer: #{similarityScore}"