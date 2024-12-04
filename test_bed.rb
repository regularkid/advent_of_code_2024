s = "1a"
30.times do
    puts s
    s.next!
end

puts [1, 2, 3, 4, 5].sample

def odd_or_even(numbers)
    numbers.map do |number|
        number.odd? ? "odd" : "even"
    end
end
  
puts odd_or_even([1,2,4,3]).to_s

puts case (1..100).to_a.sample
        when 0..33
            "Bottom Third"
        when 34..66
            "Middle Third"
        when 67..99
            "Top Third"
        else
            "One Hundred"
        end

puts "." * 10

f = "%{hello} world"
puts f % {hello:"Hey"}