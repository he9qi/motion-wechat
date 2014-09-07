WechatSDK for RubyMotion
====================

- RubyMotion wrapper for [WechatSDK](https://open.weixin.qq.com)
- Improving ...

## Setup

Add WechatMotion to your Gemfile, and run `bundle install`:
```ruby
gem 'motion-cocoapods'
gem 'wechat-motion'
```

Edit the Rakefile of your RubyMotion project and add the following require line:
```ruby
# After the line that require Rubymotion
require 'bundler'
Bundler.require
```

Then add WeChatSDK to your pods list and setup configuration in your Rakefile:
```ruby
app.pods do
  pod 'WeChatSDK'
end

MotionWechat::Config.setup(app, 'app_key', 'app_secret')
```

Initialize in app_delegate.rb
```ruby
MotionWechat::API.instance.register
```

Usage
==========

Basic:

```ruby
MotionWechat::API.instance.send_webpage "http://www.rubymotion.com", \
  title: "Ruby Motion", description: "Awesome way to write ios/osx app"
```

## TODO
- delegate helpers, i.e. `WXApi.handleOpenURL(url, delegate:self)`

## Contributions

Fork, please!
