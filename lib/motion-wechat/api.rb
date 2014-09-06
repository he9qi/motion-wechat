module MotionWechat
  module API

    InvalidMediaObject = Class.new StandardError

    def initialize(key, secret, options={})
      @key    = key
      @secret = secret
    end

    def register
      WXApi.registerApp(@key)
    end

    def self.instance
      @config   ||= NSBundle.mainBundle.objectForInfoDictionaryKey MotionWechat::Config.info_plist_key
      @instance ||= new @config["key"], @config["secret"]
    end

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

    # send webpage url
    # def send_webpage(page_url, params={})
    #   send_message_with(params) do |options|
    #     obj = WXWebpageObject.object
    #     obj.webpageUrl = page_url
    #     obj
    #   end
    # end

    # def send_video(video_url, params={})
    #   send_message_with(params) do |options|
    #     obj = WXVideoObject.object
    #     obj.videoUrl = video_url
    #     obj
    #   end
    # end
    #
    # def send_music(video_url, params={})
    #   send_message_with(params) do |options|
    #     obj = WXMusicObject.object
    #     obj.musicUrl = music_url
    #     obj
    #   end
    # end
    #
    # def send_image(image_data, params={})
    #   send_message_with(params) do |options|
    #     obj = WXImageObject.object
    #     obj.imageData = imageData
    #     obj
    #   end
    # end

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
