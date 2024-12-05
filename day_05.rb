require 'set'

mustComeAfterRules = {}
middlePageSum = 0
File.readlines("day_05_input.txt").each do |line|
    case line
    when /\d+\|\d+/
        pages = line.delete("\n").split("|").map(&:to_i)
        if !mustComeAfterRules.key?(pages[0])
            mustComeAfterRules[pages[0]] = Set.new
        end
        mustComeAfterRules[pages[0]].add(pages[1])
    when /(\d+,*)+/
        updateOrder = line.split(",").map(&:to_i)
        before = Set.new
        after = Set.new
        after.merge(updateOrder)

        isCorrectlyOrdered = true
        updateOrder.each do |page|
            after.delete(page)

            if mustComeAfterRules.key?(page)
                mustComeAfterRules[page].each do |afterPage|
                    if before.include?(afterPage)
                        isCorrectlyOrdered = false
                        break
                    end
                end
            end

            before.add(page)
        end

        if isCorrectlyOrdered
            middlePage = updateOrder[updateOrder.length/2]
            middlePageSum += middlePage
        end
    end
end

puts "Part 1 Answer: #{middlePageSum}"