# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'motion_data_wrapper/version'

Gem::Specification.new do |s|
  s.name          = "motion_data_wrapper"
  s.version       = MotionDataWrapper::VERSION
  s.authors       = ["Matt Brewer"]
  s.email         = ["matt.brewer@me.com"]
  s.homepage      = "https://github.com/macfanatic/motion_data_wrapper"
  s.summary       = "Provides an easy ActiveRecord-like interface to CoreData"
  s.description   = "Forked from the mattgreen/nitron gem, this provides an intuitive way to query and persist data in CoreData, while letting you use the powerful Xcode data modeler and versioning tools for schema definitions."

  s.files         = `git ls-files lib`.split("\n")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
