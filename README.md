WechatSDK for RubyMotion
====================
[![Code Climate](https://codeclimate.com/github/he9qi/motion-wechat.png)](https://codeclimate.com/github/he9qi/motion-wechat)

This is a RubyMotion wrapper for [WechatSDK](https://open.weixin.qq.com) to integrate [WeChat](http://www.wechat.com) API with your Rubymotion app. See http://dev.wechat.com/wechatapi/documentation

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

Then register app in your `app_delegate.rb`
```ruby
MotionWechat::API.instance.registerApp
```


Usage
==========

Basic:

```ruby
MotionWechat::API.instance.send_webpage "http://www.rubymotion.com", \
  title: "Ruby Motion", description: "Awesome way to write ios/osx app"
```

Wechat Authorization:

#### 1. authorize, this will direct user to wechat app
```ruby
MotionWechat::API.instance.authorize
```

#### 2. then make sure you have weixin delegate set up in `app_delegate.rb`
```ruby
def application(application, handleOpenURL:url)
  WXApi.handleOpenURL(url, delegate:self)
end

def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
  WXApi.handleOpenURL(url, delegate:self)
end
```

#### 3. set up `onResp` in `app_delegate.rb`. this is when it comes back from wexin app
```ruby
def onResp(resp)
  if resp.is_a? SendAuthResp
    # resp has *token* *lang* *country* *code*
    MotionWechat::API.instance.registerClient resp.code
    MotionWechat::API.instance.get_user_info do |info|
      # send *info* to server for authentication
    end
  end
end
```


## TODO
- delegate helpers, i.e. `WXApi.handleOpenURL(url, delegate:self)`
- state & key validating in `application(application, handleOpenURL:url)`

## Contributions

[smartweb](https://github.com/smartweb) 

Fork, please! 
