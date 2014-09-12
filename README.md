WechatSDK for RubyMotion
====================
[![Code Climate](https://codeclimate.com/github/he9qi/motion-wechat.png)](https://codeclimate.com/github/he9qi/motion-wechat)

- RubyMotion wrapper for [WechatSDK](https://open.weixin.qq.com)
- Improving ...
- Update** not use pod, use vendor

## Setup

Add MotionWechat to your Gemfile, and run `bundle install`:
```ruby
gem 'motion-wechat'
```

Edit the Rakefile of your RubyMotion project and add the following require line:
```ruby
# After the line that require Rubymotion
require 'bundler'
Bundler.require
```

Then setup configuration in your Rakefile:
```ruby
MotionWechat::Config.setup(app, 'app_key', 'app_secret')
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
