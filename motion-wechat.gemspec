require File.expand_path('../lib/motion-wechat/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = "motion-wechat"
  s.version     = MotionWechat::VERSION
  s.summary     = "Rubymotion wrapper for WeChatSDK"
  s.description = "Rubymotion gem to easily use WeChatSDK"
  s.authors     = ["Qi He"]
  s.email				= "qhe@heyook.com"
  s.homepage		= "http://github.com/he9qi/motion-wechat"
  s.license     = "MIT"

  s.require_paths = ["lib"]
  s.files       = Dir.glob('lib/**/*.rb')
  s.files      << 'README.md'
  s.test_files  = Dir.glob('spec/**/*.rb')

  s.add_runtime_dependency "motion-cocoapods", '~> 1.5'
end
