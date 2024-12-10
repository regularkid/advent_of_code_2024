isFileDigit = true
diskMap = []
fileId = 0

# Build non-compated disk map
File.read("day_09_input_example.txt").chars do |c|
    numBlocks = c.to_i
    (1..numBlocks).each do
        diskMap.append(isFileDigit ? fileId : -1)
    end

    if isFileDigit
        fileId += 1
    end
    isFileDigit = !isFileDigit
end

# Compact disk map (part 1)
# endIndex = diskMap.length - 1
# (0...diskMap.length).each do |index|
#     if diskMap[index] == -1
#         diskMap[index] = diskMap[endIndex]
#         diskMap[endIndex] = -1
#         while endIndex > index && diskMap[endIndex] == -1
#             endIndex -= 1
#         end
#     end

#     if index >= endIndex
#         break
#     end
# end

# Compact disk map (part 2)
endIndex = diskMap.length - 1
(0...diskMap.length).each do |index|
    if diskMap[index] == -1
        diskMap[index] = diskMap[endIndex]
        diskMap[endIndex] = -1
        while endIndex > index && diskMap[endIndex] == -1
            endIndex -= 1
        end
    end

    if index >= endIndex
        break
    end
end

# Calculate checksum
checksum = 0
diskMap.each_with_index do |value, index|
    if value == -1
        next
    end

    checksum += (value * index)
end

puts "Checksum: #{checksum}"