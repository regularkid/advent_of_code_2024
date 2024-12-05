require 'set'

mustComeAfterRules = {}
mustComeBeforeRules = {}
middlePageSum = 0
fixedMiddlePageSum = 0
File.readlines("day_05_input.txt").each do |line|
    case line
    when /\d+\|\d+/
        pages = line.delete("\n").split("|").map(&:to_i)
        if !mustComeAfterRules.key?(pages[0])
            mustComeAfterRules[pages[0]] = Set.new
        end
        if !mustComeBeforeRules.key?(pages[1])
            mustComeBeforeRules[pages[1]] = Set.new
        end
        mustComeAfterRules[pages[0]].add(pages[1])
        mustComeBeforeRules[pages[1]].add(pages[0])
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
        else
            updateOrder.sort! do |a,b|
                if mustComeAfterRules.key?(a) && mustComeAfterRules[a].include?(b)
                    -1
                elsif mustComeBeforeRules.key?(b) && mustComeBeforeRules[b].include?(a)
                    1
                else
                    1
                end
            end
            middlePage = updateOrder[updateOrder.length/2]
            fixedMiddlePageSum += middlePage
        end
    end
end

puts "Part 1 Answer: #{middlePageSum}"
puts "Part 2 Answer: #{fixedMiddlePageSum}"