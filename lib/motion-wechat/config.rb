module MotionWechat
  module Config
    extend self

    def info_plist_key
      "WechatConfig"
    end

    def setup(app, key, secret, opts={})
      options = {
        bundle_url_name: "weixin",
        key: key,
        secret: secret
      }.merge(opts)

      app.info_plist[info_plist_key] = options.select { |k| k == :key || k == :secret }

      bundle_url_types = [
          { 'CFBundleURLName'    => "weixin",
            'CFBundleURLSchemes' => [app.info_plist[info_plist_key][:key]] }
        ]

      if app.info_plist['CFBundleURLTypes']
        app.info_plist['CFBundleURLTypes'] += bundle_url_types
      else
        app.info_plist['CFBundleURLTypes'] = bundle_url_types
      end
    end

  end
end
