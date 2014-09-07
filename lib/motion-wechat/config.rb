module MotionWechat
  module Config
    extend self

    def info_plist_key
      "WechatConfig"
    end

    # Setup wechat information to rubymotion app, i.e. key, secret...
    #
    # Example: (in Rakefile)
    #
    #   Motion::Project::App.setup do |app|
    #     ...
    #     MotionWechat::Config.setup(app, 'app_key', 'app_secret')
    #   end
    #
    # Arguments:
    #   RubyMotion app: (Motion::Project::App)
    #   Wechat key:     (String)
    #   Wechat secret:  (String)
    #   other options:  (Hash)
    def setup(app, key, secret, opts={})
      options = {
        key: key,
        secret: secret
      }.merge(opts)

      app.info_plist[info_plist_key] = options.select { |k| k == :key || k == :secret }

      bundle_url_types = [
          { 'CFBundleURLName'    => "weixin",
            'CFBundleURLSchemes' => [app.info_plist[info_plist_key][:key]] }
        ]

      if app.info_plist['CFBundleURLTypes']
        app.info_plist['CFBundleURLTypes'] << bundle_url_types
      else
        app.info_plist['CFBundleURLTypes'] = bundle_url_types
      end
    end

  end
end
