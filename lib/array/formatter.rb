# array-formatter.rb
#
# Author: Alan K. Stebbens <aks@stebbens.org>
#
# ARRAY.to_html  -- format an array of arrays into an HTML table string
# ARRAY.to_csv   -- format an array of arrays into a CSV string
# ARRAY.to_table -- format an array of arrays into an ASCII table string
# ARRAY.to_yaml  -- format an array of arrays as a YAML string
#

class Array

  # string = ARRAY.to_html indent=0
  #
  # Return an HTML representation of an array of arrays as an
  # HTML table.  If indent given, indent the <table> by that
  # many spaces.

  def to_html indent=0
    require 'cgi'
    s = self.wrap_map_html_data("table", indent + 0) do |row,   rx|
         row.wrap_map_html_data("tr",    indent + 1) do |field, fx|
           tag = rx == 0 ? 'th' : 'td'
           (' ' *                       (indent + 2)) +   # indention
           "<#{tag}>"                                 +   # open tag
           (field && CGI.escapeHTML(field) || '')     +   # cell text
           "</#{tag}>\n"                                  # close tag
         end
    end
    s
  end

  # string = ARRAY.wrap_map_html_data TAG, INDENT {|DATA, INDEX| block}
  #
  # Return a string HTML representation of an array of data, starting with
  # <TAG> and ending with </TAG>, and invoking the block on each array item,
  # passing the DATA item with its INDEX.

  def wrap_map_html_data tag, indent=0
    s = ''
    prefix = ' ' * indent
    s << prefix + "<#{tag}>\n"
    self.each_with_index {|data, x| s << ((yield data, x) || '') }
    s << prefix + "</#{tag}>\n"
    s
  end

  # string = ARRAY.to_csv
  #
  # Convert an array of arrays to CSV representation Basically, each
  # top-level array row becomes a line of CSV data The 2nd level
  # arrays become individual rows of data, separated by commas.  Each
  # 2nd level array item gets quoted if it contains any punctuation
  # characters.

  def to_csv
    self.map {|row|
      row.map {|f|
        f =~ /[[:punct:]]/ ?  '"' + f.gsub(/"/, '""') + '"' : f }.
      join(",")}.
    join("\n")
  end

  # string = ARRAY.to_yaml
  #
  # Convert an array of arrays to YAML (using built-in core methods)

  def to_yaml
    require 'yaml'
    YAML.dump(self)
  end

  # string = ARRAY.to_table type
  #
  # Convert an array of arrays to ASCII table representation
  #
  # to create a box, we need to describe the parts of it:
  # (be sure to used fixed-width font)
  #
  #  +-------+-------+  <== top border
  #  | cell1 | cell2 |  <== data row
  #  +-------+-------+  <== inner border
  #  | r2c1  | r2c2  |  <== data row
  #  +-------+-------+  <== bottom border
  #  ^       ^       ^
  #  |       |       +--<== right
  #  |       +----------<== middle
  #  +------------------<== left
  #
  # Given these, there are 15 specific characters for line drawing:
  #
  #      Location          Symbol          Location          Symbol
  #   ================     ======       ================     ======
  #     top-left-border     tlb           left-inner-border   lib
  #     top-border           tb                inner-border    ib
  #     top-inner-border    tib         middle-inner-border   mib
  #     top-right-border    trb          right-inner-border   rib
  #
  #     left-data-border    ldb          bottom-left-border   blb
  #    inner-data-border    idb          bottom-border         bb
  #    right-data-border    rdb          bottom-inner-border  bib
  #                                      bottom-right-border  brb
  #
  # In the specs below, the characters are given in the same order as above.
  # The characters are index by the given symbols.

  class TableChars < Hash

    @@table_chars = {}
    @@table_char_names = %w( tlb tb tib trb ldb idb rdb lib ib mib rib blb bb bib brb ).map{|n|n.intern}

    def initialize name, fmt_chars, start=nil, stop=nil
      @chars = self
      @@table_chars[name] = @chars
      if fmt_chars.class == Symbol
        @@table_chars[name] = @chars = @@table_chars[fmt_chars].dup
      elsif fmt_chars.class == Array
        chars = fmt_chars.dup
        @@table_char_names.each{|n| @chars[n] = chars.shift || raise(ArgumentError, "Missing characters from table drawing charset!")}
      end
      @start = start
      @stop = stop
      @chars
    end

    @@table_char_names.each do |name|
      define_method(name) { @chars[name] }
    end

    # TableChars.get NAME
    #
    # Return the TableChars object for NAME, or nil

    def self.get name
      @chars = @@table_chars[name]
    end

    attr_reader :start, :stop

    def wrap text
      (@start || '') + text + (@stop || '')
    end

  end

  # :ascii -- an ASCII table

  TableChars.new :ascii, %w( + - + +   | | |  + - + +   + - + +  )

  # :unicode_single - a table with thick outer border, and thin inner lines.
  TableChars.new :unicode_single, [ "\u250F", "\u2501", "\u252F", "\u2513",     # tlb,  tb, tib, trb
                                    "\u2503", "\u2502", "\u2503",               # ldb, idb, rdb
                                    "\u2520", "\u2500", "\u253C", "\u2528",     # lib,  ib, mib, rib
                                    "\u2517", "\u2501", "\u2537", "\u251B" ]    # blb,  bb, bib, brb

  # :unicode_bold - a table with thick borders everywhere
  TableChars.new :unicode_bold,   [ "\u250F", "\u2501", "\u2533", "\u2513",     # tlb,  tb, tib, trb
                                    "\u2503", "\u2503", "\u2503",               # ldb, idb, rdb
                                    "\u2523", "\u2501", "\u254B", "\u252B",     # lib,  ib, mib, rib
                                    "\u2517", "\u2501", "\u253B", "\u251B" ]    # blb,  bb, bib, brb

  # :unicode_double - a table with double lines everywhere
  TableChars.new :unicode_double, [ "\u2554", "\u2550", "\u2566", "\u2557",     # tlb,  tb, tib, trb
                                    "\u2551", "\u2551", "\u2551",		# ldb, idb, rdb
                                    "\u2560", "\u2550", "\u256C", "\u2563",     # lib,  ib, mib, rib
                                    "\u255A", "\u2550", "\u2569", "\u255D" ]    # blb,  bb, bib, brb

  # :unicode_mixed - a table with double outer lines, and single inner lines
  TableChars.new :unicode_mixed,  [ "\u2554", "\u2550", "\u2564", "\u2557",     # tlb,  tb, tib, trb
                                    "\u2551", "\u2502", "\u2551",		# ldb, idb, rdb
                                    "\u255F", "\u2500", "\u253C", "\u2562",     # lib,  ib, mib, rib
                                    "\u255A", "\u2550", "\u2567", "\u255D" ]    # blb,  bb, bib, brb

  TableChars.new :dos_single,	  [ "\xDA", "\xC4", "\xC2", "\xBF",	        # tlb,  tb, tib, trb
                                    "\xB3", "\xB3", "\xB3",		        # ldb, idb, rdb
                                    "\xC3", "\xC4", "\xC5", "\xB4",	        # lib,  ib, mib, rib
                                    "\xC0", "\xC4", "\xC1", "\xD9" ]	        # blb,  bb, bib, brb

  TableChars.new :dos_double, 	  [ "\xC9", "\xCD", "\xCB", "\xBB",	        # tlb,  tb, tib, trb
                                    "\xBA", "\xBA", "\xBA",		        # ldb, idb, rdb
                                    "\xCC", "\xCD", "\xCE", "\xB9",	        # lib,  ib, mib, rib
                                    "\xC8", "\xCD", "\xCA", "\xBC" ]	        # blb,  bb, bib, brb

  TableChars.new :vt100,	  [ "\x6C", "\x71", "\x77", "\x6B",	        # tlb,  tb, tib, trb
                                    "\x78", "\x78", "\x78",		        # ldb, idb, rdb,
                                    "\x74", "\x71", "\x6E", "\x75",	        # lib,  ib, mib, rib
                                    "\xCD", "\x71", "\x76", "\x6A" ],           # blb,  bb, bib, brb
                                  "\e(0", "\e(B"

  TableChars.new :unicode, :unicode_single
  TableChars.new :dos,     :dos_single


  def to_table name=:ascii
    @chars = TableChars.get name

    # compute the maximum widths and the alignment of each column
    @widths = []
    @align = []
    self.each_with_index do |row,rx|
      row.each_with_index do |col,cx|
        @widths[cx] ||= 0
        l = col.to_s.length
        @widths[cx] = l if l > @widths[cx]
        if rx == 0
          type = nil
        else
          type = case (col || '')
                 when /^\$?\s*\d[,\d]*\.\d*$/  then :rjust   # real number and/or currency
                 when /^\$?\s*\d[,\d]*$/       then :rjust   # integer
                 when /^$/, /^\s*-\s*$/, nil   then nil       # empty values have no alignment
                 else :ljust
                 end
        end
        @align[cx] ||= (col ? type : nil)
        @align[cx] = :ljust if type && @align[cx] != type && rx > 0
      end
    end

    # now format each row
    s = ''
    self.each_with_index do |row, rx|
      s << table_line(rx == 0 ? :top : :middle)
      s << table_data(row)
    end
    s << table_line(:bottom)
    s
  end

  ##
  # table_line position
  #
  # generate a table line for position (:top, :middle, :bottom)
  #
  def table_line position
    c = @chars
    left, line, mid, right = case position
                             when :top     then [c[:tlb], c[:tb], c[:tib], c[:trb]]
                             when :middle  then [c[:lib], c[:ib], c[:mib], c[:rib]]
                             when :bottom  then [c[:blb], c[:bb], c[:bib], c[:brb]]
                             end
    s = @chars.wrap(left + @widths.map{|w| line * (w + 2)}.join(mid) + right) + "\n"
    s
  end

  ##
  # table_data data
  #
  # generate a data row as part of a table

  def table_data data
    left, middle, right = [@chars[:ldb], @chars[:idb], @chars[:rdb]]
    a = []
    data.each_with_index do |item, x|
      a << (' ' + item.to_s.send(@align[x] || :ljust, @widths[x]) + ' ')
    end
    s = @chars.wrap(left) + a.join(@chars.wrap(middle)) + @chars.wrap(right) + "\n"
    s
  end

end
