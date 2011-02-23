# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'fake_name_generator'

Gem::Specification.new do |s|
  s.name        = "fake_name_generator"
  s.version     = FakeNameGenerator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill Turner"]
  s.email       = ["billturner@gmail.com"]
  s.homepage    = "https://github.com/billturner/fake_name_generator"
  s.summary     = "A simple Ruby wrapper to the FakeNameGenerator.com API"
  s.description = "A simple Ruby wrapper to the FakeNameGenerator.com API"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "fake_name_generator"

  s.add_development_dependency "bundler", ">= 1.0.7"
  s.add_development_dependency "rspec", ">= 2.5.0"
  s.add_development_dependency "fakeweb", ">= 1.3.0"
  s.add_dependency "json", ">= 1.5.1"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

