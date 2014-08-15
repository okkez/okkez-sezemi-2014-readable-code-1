#! /usr/bin/env ruby

ARGF.readlines.each_with_index do |line, index|
  puts "#{index}: #{line.chomp}"
end
