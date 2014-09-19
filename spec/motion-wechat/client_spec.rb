describe MotionWechat::Client do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
    @client = MotionWechat::Client.new "appid", "appsecret", "code"
  end

  it "should get id, secret and site" do
    @client.id.should == "appid"
    @client.secret.should == "appsecret"
    @client.site == "https://api.weixin.qq.com"
  end

  it "should get token url" do
    @client.token_url.should == "https://api.weixin.qq.com/sns/oauth2/access_token"
  end

  context "access token" do

    before do
      @res = File.read NSBundle.mainBundle.resourcePath.stringByAppendingPathComponent("token.json")
      @url = "https://api.weixin.qq.com/sns/oauth2/access_token" + \
        "?appid=appid&secret=appsecret&code=code&grant_type=authorization_code"
    end

    it "gets token" do
      stub_request(:get, @url).
              to_return(json: @res)
      @res = nil

      @client.get_token do |token|
        @token = token
        resume
      end

      wait_max 1.0 do
        @token.should.be.kind_of MotionWechat::AccessToken
      end
    end

  end

  context "get info" do

    before do
      @res = File.read NSBundle.mainBundle.resourcePath.stringByAppendingPathComponent("user.json")
      @url = "https://api.weixin.qq.com/sns/user_info?access_token=token&openid=openid"
    end

    it "gets user info" do
      stub_request(:get, @url).
              to_return(json: @res)
      @res = nil

      @client.get("/sns/user_info", access_token: "token", openid: "openid") do |info|
        @info = info
        resume
      end

      wait_max 1.0 do
        @info.should.be.kind_of Hash
        @info["nickname"].should == "monkey"
      end
    end

  end


end
