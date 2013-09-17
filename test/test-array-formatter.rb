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

  def test_to_table_default
    s = @@a.to_table
    puts s
  end

  def test_to_table_unicode
    s = @@a.to_table(:unicode)
    puts s
  end

end
