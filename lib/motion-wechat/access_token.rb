module MotionWechat
  class AccessToken
    attr_reader :client, :token, :expires_in, :openid, :params
    attr_accessor :options, :refresh_token

    class << self

      # Initializes an AccessToken from a Hash
      #
      # Example:
      #   MotionWechat::AccessToken.from_hash @client, {}
      #
      # Arguments:
      #   client: (MotionWechat::Client)
      #   hash: (Hash)
      #
      def from_hash(client, hash)
        new(client, hash.delete('access_token') || hash.delete(:access_token), hash)
      end

    end

    # Initalize an AccessToken
    #
    # Example:
    #   MotionWechat::AccessToken.new @client, 'token', {}
    #
    # Arguments:
    #   client: (MotionWechat::Client)
    #   token: (String)
    #   hash: (Hash)
    #
    def initialize(client, token, opts = {})
      @client = client
      @token = token.to_s
      [:refresh_token, :expires_in, :openid].each do |arg|
        instance_variable_set("@#{arg}", opts.delete(arg) || opts.delete(arg.to_s))
      end
      @expires_in ||= opts.delete('expires')
      @expires_at ||= Time.now.to_i + @expires_in.to_i
      @params = opts
    end

    # Get information using access token
    #
    # Example:
    #   @token.get "/sns/userinfo", { |res| ... }
    #
    # Arguments:
    #   path: (String)
    #   opts: (hash)
    #
    def get(path, opts = {}, &block)
      @client.get path, opts.merge({access_token: @token}), &block
    end

    # Get user information
    #
    # Example:
    #   @token.get_user_info { |info| ... }
    #
    def get_user_info(&block)
      get "/sns/userinfo", openid: @openid do |info|
        block.call oauth2_wrapp(info)
      end
    end

    private

    # Wrap with OAuth2 structure
    def oauth2_wrapp(info)
      {
        uid: @openid,
        provider: "weixin",
        info: {
          image: info['headimgurl'],
          nickname: info['nickname'],
          name: info['nickname']
        },
        extra: info
      }
    end

  end

end
