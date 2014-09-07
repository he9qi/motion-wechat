module MotionWechat
  module API

    InvalidMediaObject = Class.new StandardError

    def initialize(key, secret, options={})
      @key    = key
      @secret = secret
    end

    # Register WechatAPI
    def register
      WXApi.registerApp(@key)
    end

    # Returns singleton instance of MotionWechat
    #
    # Example:
    #   MotionWechat::API.instance
    #
    def self.instance
      @config   ||= NSBundle.mainBundle.objectForInfoDictionaryKey MotionWechat::Config.info_plist_key
      @instance = new @config["key"], @config["secret"]
    end

    # Send media objects, i.e. webpage, video, music and image to wechat
    #
    # Example:
    #   MotionWechat::API.instance.send_video video_url, title: 't', description: 'desc'
    #
    # Arguments:
    #   media object: (String / NSData)
    #   options: (Hash)
    %w(webpage video music image).each do |meth|
      define_method("send_#{meth}") do |arg, params|
        property = case meth
          when "webpage", "video", "music"
            "#{meth}Url"
          when "image"
            "imageData"
          else
            raise InvalidMediaObject
          end

        send_message_with(params) do |options|
          klass = Object.const_get "WX#{meth.capitalize}Object"
          obj   = klass.object
          obj.send "#{property}=", arg
          obj
        end

      end
    end

    # Send text to wechat
    #
    # Example:
    #   MotionWechat::API.instance.send_text "hello, motion"
    #
    # Arguments:
    #   text: (String)
    def send_text(text)
      req = SendMessageToWXReq.alloc.init
      req.bText = false
      req.text = text
      WXApi.sendReq(req)
    end

    private

    ###
    # scene: WXSceneTimeline | WXSceneSession | WXSceneFavorite
    # b_text: is this a text message?
    # title, :description, thumbnail
    ###
    def send_message_with(params, &block)
      options = {
        scene: WXSceneSession,
        thumbnail: nil,
        b_text: false
      }.merge(params)

      message = WXMediaMessage.message
      message.setThumbImage options[:thumbnail]
      message.title = options[:title]
      message.description = options[:description]

      obj = block.call(options)

      message.mediaObject = obj

      req = SendMessageToWXReq.alloc.init
      req.bText = options[:b_text]
      req.scene = options[:scene]
      req.message = message
      WXApi.sendReq(req)
    end

  end

end
