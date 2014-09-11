# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end


Motion::Project::App.setup do |app|
  app.name = 'MotionWechat'
  app.identifier = 'com.heyook.motion-wechat'

  # app.vendor_project 'vendor/Pods/WechatSDK/SDKExport', :static

  MotionWechat::Config.setup(app, 'app_key', 'app_secret')
end
