#require 'rake'

require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/test[-_]*.rb'
  t.verbose = false
end

task :default => :test
