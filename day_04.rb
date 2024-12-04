$letterGrid = []
File.readlines("day_04_input.txt").each do |line|
    $letterGrid.push(line.delete("\n").chars)
end

LetterWithOffset = Struct.new(:letter, :xOffset, :yOffset)
$validLetterOffsetSetsPart1 = [
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", 1, 0), LetterWithOffset.new("A", 2, 0), LetterWithOffset.new("S", 3, 0)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", -1, 0), LetterWithOffset.new("A", -2, 0), LetterWithOffset.new("S", -3, 0)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", 0, 1), LetterWithOffset.new("A", 0, 2), LetterWithOffset.new("S", 0, 3)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", 0, -1), LetterWithOffset.new("A", 0, -2), LetterWithOffset.new("S", 0, -3)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", 1, 1), LetterWithOffset.new("A", 2, 2), LetterWithOffset.new("S", 3, 3)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", -1, 1), LetterWithOffset.new("A", -2, 2), LetterWithOffset.new("S", -3, 3)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", -1, -1), LetterWithOffset.new("A", -2, -2), LetterWithOffset.new("S", -3, -3)],
    [LetterWithOffset.new("X", 0, 0), LetterWithOffset.new("M", 1, -1), LetterWithOffset.new("A", 2, -2), LetterWithOffset.new("S", 3, -3)],
]

$validLetterOffsetSetsPart2 = [
    [LetterWithOffset.new("A", 0, 0), LetterWithOffset.new("M", -1, -1), LetterWithOffset.new("S", 1, 1), LetterWithOffset.new("M", 1, -1), LetterWithOffset.new("S", -1, 1)],
    [LetterWithOffset.new("A", 0, 0), LetterWithOffset.new("M", -1, -1), LetterWithOffset.new("S", 1, 1), LetterWithOffset.new("M", -1, 1), LetterWithOffset.new("S", 1, -1)],
    [LetterWithOffset.new("A", 0, 0), LetterWithOffset.new("M", 1, 1), LetterWithOffset.new("S", -1, -1), LetterWithOffset.new("M", -1, 1), LetterWithOffset.new("S", 1, -1)],
    [LetterWithOffset.new("A", 0, 0), LetterWithOffset.new("M", 1, 1), LetterWithOffset.new("S", -1, -1), LetterWithOffset.new("M", 1, -1), LetterWithOffset.new("S", -1, 1)],
]

def IsLetterAtPos(letter, x, y)
    if x < 0 || y < 0 || x >= $letterGrid[0].length || y >= $letterGrid.length
        return false
    end

    return $letterGrid[y][x] == letter
end

numXMASFound = 0
(0...$letterGrid.length).each do |y|
    (0...$letterGrid[y].length).each do |x|
        #$validLetterOffsetSetsPart1.each do |letterWithOffsetSet|
        $validLetterOffsetSetsPart2.each do |letterWithOffsetSet|
            isValid = true
            letterWithOffsetSet.each do |letterWithOffset|
                if !IsLetterAtPos(letterWithOffset.letter, x + letterWithOffset.xOffset, y + letterWithOffset.yOffset)
                    isValid = false
                    break
                end
            end

            if isValid
                numXMASFound += 1
            end
        end
    end
end

puts numXMASFound