require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'
begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the fake_name_generator gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'fake_name_generator documentation'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :spec

