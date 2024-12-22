secret_sum = 0
num_iterations = 2000
mul_by_64_shift = 6
div_by_32_shift = 5
mul_by_2048_shift = 11
mod_val = 0x1000000 - 1
File.readlines("day_22_input.txt").each do |line|
    n = line.strip.to_i
    num_iterations.times do
        n = (n ^ (n << mul_by_64_shift)) & mod_val   # multiply by 64, XOR with original value, mod 16777216
        n = (n ^ (n >> div_by_32_shift)) & mod_val   # divide by 32, XOR with original value, mod 16777216
        n = (n ^ (n << mul_by_2048_shift)) & mod_val # multiply by 2048, XOR with original value, mod 16777216
    end
    secret_sum += n
end
puts "Part 1 Answer: #{secret_sum}"