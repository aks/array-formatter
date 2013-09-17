#!/usr/bin/env ruby

$LOAD_PATH.unshift '.', './test', './lib'

require 'array/formatter'
require 'test-helper'

class Test_Array_Formatter < MiniTest::Unit::TestCase

  @@a = [ %w( Company  Name  Address  Phone  Email ),
          [ 'New Company', 'First Last', 'Somewhere, US', '123-45-6789', 'user@sample.com' ],
          [ 'Old Company', 'First2 Last2', 'Somewhere else, US', '987-65-4321', 'user2@sample.com' ],
          [ 'No Company',  'First3 Last3', 'Elsewhere ZZ', '763-34-1234', 'user3@sample.com' ]
        ]

  @@a2 = [ %w( Region    State      Sales   ),
           %w( Northwest WA       $2,100,500 ),
           %w( Northwest OR         $900,800 ),
           %w( Northeast NY       $8,120,000 ),
           %w( Northeast MN         $489,500 ),
           %w( Southeast GA       $2,111,200 ),
           %w( Southeast FL       $9,388,000 ),
           %w( Southwest AZ       $7,377,000 ) ]
        

  def test_to_table_default
    s = @@a.to_table
    puts s
  end

  def test_to_table_unicode
    s = @@a.to_table(:unicode)
    puts s
  end

  def test_to_table_alignments
    s = @@a2.to_table
    puts s
    puts ''
    s = @@a2.to_table(:unicode)
    puts s
  end

end
