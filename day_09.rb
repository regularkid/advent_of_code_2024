isFileDigit = true
DiskMapSection = Struct.new(:fileId, :numBlocks)
diskMap = []
fileId = 0

# Build non-compated disk map
File.read("day_09_input.txt").chars do |c|
    numBlocks = c.to_i
    diskMap.append(DiskMapSection.new(isFileDigit ? fileId : -1, numBlocks))

    if isFileDigit
        fileId += 1
    end
    isFileDigit = !isFileDigit
end

# Compact disk map (part 2)
(diskMap.length - 1).downto(0) do |index|
    sectionInfo = diskMap[index]
    if sectionInfo.fileId == -1
        next
    end

    (0...index).each do |checkIndex|
        if diskMap[checkIndex].fileId != -1
            next
        end

        if diskMap[checkIndex].numBlocks >= sectionInfo.numBlocks
            diskMap.insert(checkIndex, DiskMapSection.new(sectionInfo.fileId, sectionInfo.numBlocks))
            sectionInfo.fileId = -1
            diskMap[checkIndex + 1].numBlocks -= sectionInfo.numBlocks
            break
        end
    end
end

# Calculate checksum
checksum = 0
blockIndex = 0
diskMap.each do |sectionInfo|
    if sectionInfo.fileId == -1
        blockIndex += sectionInfo.numBlocks
    else
        sectionInfo.numBlocks.times do
            checksum += (sectionInfo.fileId * blockIndex)
            blockIndex += 1
        end
    end
end

puts "Checksum: #{checksum}"