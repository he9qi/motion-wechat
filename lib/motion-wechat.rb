unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'afmotion'
require 'bubble-wrap/core'
require_relative 'motion-wechat/config'

Motion::Project::App.setup do |app|
  Dir.glob(File.join(File.dirname(__FILE__), 'motion-wechat/*.rb')).each do |file|
    app.files.unshift(file)
  end

  app.vendor_project 'vendor/SDKExport', :static

  app.pods ||= Motion::Project::CocoaPods.new(app)
  app.pods do
	  pod 'AFNetworking'
	end

end
