$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'MotionDataWrapperTest'
  app.version = "0.99.0"

  # Devices
  app.deployment_target = "6.0"

  app.detect_dependencies = true
end
