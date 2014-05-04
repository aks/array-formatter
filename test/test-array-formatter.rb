#!/usr/bin/env ruby

$LOAD_PATH.unshift '.', './test', './lib'

$refdir = 'test/ref'               # where the test reference output lives

# if 'save' or '--save' appears anywhere as an argument, the outputs are saved
# as reference test output.

$verbose = $save = nil
ARGV.each_with_index do |arg, x|
  case arg
  when 'save', '--save'
    $save = true
    ARGV.delete_at(x)
  when '-v', '--verbose'
    $verbose = true
  end
end

require 'helper'
#require 'array/formatter'

class Test_Array_Formatter < MiniTest::Unit::TestCase

  def ref_filename name, kind
    "#{$refdir}/#{name}-#{kind}.txt"
  end

  def read_ref name, kind
    filename = ref_filename(name, kind)
    ref = nil
    if File.exist?(filename)
      File.open(filename) { |file| ref = file.read }
    end
    ref
  end

  def write_ref name, kind, out
    filename = ref_filename(name, kind)
    unless Dir.exist?($refdir)
      Dir.mkdir $refdir
      puts "Created #{$refdir}" if $verbose
    end
    File.open(filename, 'w+') { |file| file.write out }
    printf "%d lines written to %s\n", (out.count("\n")+1), filename
  end

  def check actual, name, kind
    if $verbose
      puts ""
      puts actual
    end
    unless $save
      expected = read_ref(name, kind)
      if expected
        assert_equal actual.strip, expected.strip, "Error: at #{caller.first}:"
      else
        puts "No reference output to compare with"
      end
    else
      write_ref name, kind, actual
    end
  end

  @@a = [ %w( Company  Name  Address  Phone  Email ),
          [ 'New Company', 'First Last', 'Somewhere, US', '123-45-6789', 'user@sample.com' ],
          [ 'Old Company', 'First2 Last2', 'Somewhere else, US', '987-65-4321', 'user2@sample.com' ],
          [ 'No Company',  'First3 Last3', 'Elsewhere ZZ', '763-34-1234', 'user3@sample.com' ]
        ]

  @@b =  [ %w( Region    State      Sales    ),
           %w( Northwest WA       $2,100,500 ),
           %w( Northwest OR         $900,800 ),
           %w( Northeast NY       $8,120,000 ),
           %w( Northeast MN         $489,500 ),
           %w( Southeast GA       $2,111,200 ),
           %w( Southeast FL       $9,388,000 ),
           %w( Southwest AZ       $7,377,000 ) ]

  def test_a_table_ascii
    s = @@a.to_table
    check s, :a, :ascii
  end

  def test_a_table_unicode
    s = @@a.to_table(:unicode)
    check s, :a, :unicode
  end

  def test_a_table_unicode_single
    s = @@a.to_table(:unicode_single)
    check s, :a, :unicode_single
  end


  def test_b_table_ascii
    s = @@b.to_table
    check s, :b, :ascii
  end

  def test_b_table_unicode
    s = @@b.to_table(:unicode)
    check s, :b, :unicode
  end

  def test_b_table_unicode_double
    s = @@b.to_table(:unicode_double)
    check s, :b, :unicode_double
  end

  def test_b_table_unicode_mixed
    s = @@b.to_table(:unicode_mixed)
    check s, :b, :unicode_mixed
  end

  def test_a_to_csv
    check @@a.to_csv, :a, :csv
  end

  def test_b_to_csv
    check @@b.to_csv, :b, :csv
  end

  def test_a_to_html
    check @@a.to_html, :a, :html
  end

  def test_b_to_html
    check @@b.to_html, :b, :html
  end

  def test_a_to_yaml
    check @@a.to_yaml, :a, :yaml
  end

  def test_b_to_yaml
    check @@b.to_yaml, :b, :yaml
  end

end
