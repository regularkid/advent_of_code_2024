leftList = []
rightList = []

File.readlines("day_01_input.txt").each do |line|
    nums = line.split
    leftList.push(nums[0])
    rightList.push(nums[1])
end

leftList.sort!
rightList.sort!

totalDelta = 0
(0...leftList.length).each do |i|
    totalDelta += (Integer(leftList[i]) - Integer(rightList[i])).abs
end

puts "Part 1 Answer: #{totalDelta}"

similarityScore = 0
rightListCounts = Hash.new(0)
rightList.each { |num| rightListCounts[num] += 1 }
leftList.each { |num| similarityScore += Integer(num) * rightListCounts[num]}

puts "Part 2 Answer: #{similarityScore}"