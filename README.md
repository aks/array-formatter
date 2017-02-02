# Array::Formatter

A simple gem to reformat an array of arrays into one of several formats:

- HTML table (as a string)
- CSV string
- table (using fixed-width ASCII text or Unicode drawing characters)
- YAML string

## Installation

Add this line to your application's Gemfile:

    gem 'array-formatter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install array-formatter

## Usage

    require 'array/formatter'

    array.to_table [CHARTYPE]
    array.to_csv
    array.to_html
    array.to_yml

> Note: the `YAML` standard Ruby class defines a `to_yaml` method on arrays.

With the `to_table` method, `CHARTYPE` is one of following, and defaults
to `:ascii`:

    :ascii
    :unicode
    :unicode_double
    :unicode_single
    :unicode_mixed

See `test/ref/*` for example outputs.


## Author:

Alan K. Stebbens <aks@stebbens.org>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
