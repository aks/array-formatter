# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

$LOAD_PATH.unshift './lib', '../lib'
require 'array/formatter/version'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name        = "array-formatter"
  gem.homepage    = "https://bitbucket.org/aks_/array-formatter"
  gem.license     = "MIT"
  gem.version     = Array::Formatter::VERSION
  gem.summary     = %Q{Format an array of arrays in one of serveral string formats}
  gem.description = <<-EOF
    A simple gem to reformat an array of arrays into one of several string
    formats: HTML table; CSV; ASCII table; YAML
    EOF
  gem.email         = "aks@stebbens.org"
  gem.authors       = ["Alan K. Stebbens"]
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test[_-]*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "array-formatter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
