#!/usr/bin/env ruby
$LOAD_PATH.unshift 'lib'
require 'array/formatter'
a = %w( now is the time for all good men to come to the aid of their country )

puts "Testing default arguments"
puts a.to_columns

[false, true].each do |srt|
  (2..5).each do |col|
    puts "\nTesting dynamic columns, sort: #{srt}"
    puts a.to_columns sort: srt

    puts "\nTesting #{col} columns, sort: #{srt}"
    puts a.to_columns columns: col, sort: srt

    puts "\nTesting #{col} columns, sort: #{srt}, separator: ' | '"
    puts a.to_columns columns: col, sort: srt, separator: ' | '

    [:left, :right, :just].each do |align|
      puts "\nTesting #{col} columns, sort: #{srt}, sep bar, #{align}"
      puts a.to_columns columns: col, sort: srt, separator: " | ", align: align

      [false, true].each do |lines|
        puts "\nTesting #{col} columns, sort: #{srt}, align: #{align}, lines: #{lines}"
        puts a.to_columns columns: col, sort: srt, separator: " | ", align: align, lines: lines
      end
    end
  end
end



exit
