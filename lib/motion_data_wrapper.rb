require 'motion_data_wrapper/version'
require 'bubble-wrap'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|

  # Load class definitions that require the following modules, these will get compiled after b/c we're using "unshift"
  Dir[File.join(File.dirname(__FILE__), "motion_data_wrapper/*.rb")].each { |f| app.files.unshift(f) }
  
  # Load in the modules
  %w(errors model relation).each do |mod|
    Dir[File.join(File.dirname(__FILE__), "motion_data_wrapper/#{mod}/**/*.rb")].each { |f| app.files.unshift(f) }
  end

  app.frameworks << "CoreData" unless app.frameworks.include?("CoreData")
end
