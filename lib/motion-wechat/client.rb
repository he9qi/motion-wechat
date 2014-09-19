module MotionWechat
  class Client
    attr_reader :id, :secret, :site
    attr_accessor :options

    # Instantiate a new OAuth 2.0 client using the Client ID
    # and Client Secret registered to your application.
    #
    # Example:
    #   MtionWechat::Client.new 'key', 'secret', 'code', {}
    #
    # Arguments:
    #   key: (String)
    #   secret: (String)
    #   code: (String)
    #   options: (Hash)
    #
    def initialize(client_id, client_secret, code, options = {})
      opts      = options.dup
      @id       = client_id
      @secret   = client_secret
      @code     = code
      @site     = opts[:site] || "https://api.weixin.qq.com"
      @options  = {
        token_url: '/sns/oauth2/access_token'
      }.merge(opts)
    end

    # Returns token url to get access token
    #
    # Example:
    #   @client.token_url
    #
    def token_url
      @site + @options[:token_url]
    end

    # Returns token url to get access token
    #
    # Example:
    #   @client.get_token do |token|
    #     p token
    #   end
    #
    def get_token(&block)
      params = "appid=#{@id}&secret=#{@secret}&code=#{@code}&grant_type=authorization_code"
      AFMotion::HTTP.get(token_url + "?" + params) do |res|
        hash  = to_hash res.body.to_s
        token = AccessToken.from_hash self, hash
        block.call token
      end
    end

    # Request information
    #
    # Example:
    #   @client.get '/sns/userinfo', openid: "openid" do |info|
    #     p info
    #   end
    #
    def get(path, opts = {}, &block)
      AFMotion::HTTP.get(@site + path, opts) do |res|
        hash = to_hash res.body.to_s
        block.call hash
      end
    end

    private

    def to_hash(string)
      BW::JSON.parse string.dataUsingEncoding(NSString.defaultCStringEncoding)
    end

  end
end
