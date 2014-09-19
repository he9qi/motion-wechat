describe MotionWechat::AccessToken do
  extend WebStub::SpecHelpers

  before do
    disable_network_access!
    hash = {
      access_token: "access_token",
      expires_in:7200,
      refresh_token:"refresh_token",
      openid:"openid",
      scope:"snsapi_userinfo"
    }
    @client = MotionWechat::Client.new "appid", "appsecret", "code"
    @token  = MotionWechat::AccessToken.from_hash @client, hash
  end

  it "should get client, token and expires" do
    @token.client.should.be.kind_of MotionWechat::Client
    @token.token.should == "access_token"
    @token.expires_in.should == 7200
    @token.openid.should == "openid"
  end

  context "get info" do

    before do
      @res = File.read NSBundle.mainBundle.resourcePath.stringByAppendingPathComponent("user.json")
      @url = "https://api.weixin.qq.com/sns/userinfo?access_token=access_token&openid=openid"
    end

    it "gets user info using get" do
      stub_request(:get, @url).
              to_return(json: @res)
      @res = nil

      @token.get("/sns/userinfo", openid: "openid") do |info|
        @info = info
        resume
      end

      wait_max 1.0 do
        @info.should.be.kind_of Hash
        @info["nickname"].should == "monkey"
      end
    end

    it "gets user info using get" do
      stub_request(:get, @url).
              to_return(json: @res)
      @res = nil

      @token.get_user_info do |info|
        @info = info
        resume
      end

      wait_max 1.0 do
        @info.should.be.kind_of Hash
        @info[:uid].should == "openid"
        @info[:provider].should == "weixin"
        @info[:info][:image].should == "http://wx.qlogo.cn/mmopen/0"
        @info[:info][:nickname].should == "monkey"
      end
    end

  end


end
