require 'rubygems'
require 'rake'
require 'rake/packagetask'
require 'rake/gempackagetask'

version = File.read(File.expand_path(__FILE__, '../VERSION')).strip
spec    = eval(File.read('accepts-flattened-values.gemspec'))

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc 'Install gem'
task :install => :gem do
  system("gem install pkg/accepts-flattened-values-#{version}.gem --no-ri --no-rdoc")
end

desc 'Release to gemcutter'
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end
