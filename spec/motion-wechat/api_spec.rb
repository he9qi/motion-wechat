describe MotionWechat::API do

  it "should call register key" do
    WXApi.stub!(:registerApp) do |key|
      key.should == "app_key"
    end
    MotionWechat::API.instance.registerApp
  end

  it "should return WXApi as wx" do
    MotionWechat::API.instance.wx.should == WXApi
  end

  describe "Send messages" do

    before { @mv = MotionWechat::API.instance }

    it "sends auth message" do
      WXApi.stub!(:sendReq) do |req|
        req.should.be.kind_of(SendAuthReq)
      end

      @mv.authorize
    end

    it 'sends web page url' do
      WXApi.stub!(:sendReq) do |req|
        req.should.be.kind_of(SendMessageToWXReq)
        req.message.should.be.kind_of(WXMediaMessage)
        req.message.mediaObject.should.be.kind_of(WXWebpageObject)
        req.message.mediaObject.webpageUrl.should == "http://www.motion-wechat.com"
      end

      @mv.send_webpage "http://www.motion-wechat.com", \
        title: "title", description: "description"
    end

    it 'sends video url' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXVideoObject)
        req.message.mediaObject.videoUrl.should == "http://www.youtube.com/1"
      end

      @mv.send_video "http://www.youtube.com/1", \
        title: "title", description: "description"
    end

    it 'sends music url' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXMusicObject)
        req.message.mediaObject.musicUrl.should == "http://www.pandora.com/1"
      end

      @mv.send_music "http://www.pandora.com/1", \
        title: "title", description: "description"
    end

    it 'sends image' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXImageObject)
      end

      @mv.send_image NSData.dataWithContentsOfFile("dummy"), \
        title: "title", description: "description"
    end

    it 'sends text' do
      WXApi.stub!(:sendReq) do |req|
        req.should.be.kind_of(SendMessageToWXReq)
        req.text.should == "hello"
      end

      @mv.send_text "hello"
    end

    describe "Scene type" do

      it "default sends to session" do
        WXApi.stub!(:sendReq) do |req|
          req.should.be.kind_of(SendMessageToWXReq)
          req.scene.should == WXSceneSession
        end

        @mv.send_webpage "http://www.motion-wechat.com", \
          title: "title", description: "description"
      end

      it "sends to time line" do
        WXApi.stub!(:sendReq) do |req|
          req.should.be.kind_of(SendMessageToWXReq)
          req.scene.should == WXSceneTimeline
        end

        @mv.send_webpage "http://www.motion-wechat.com", \
          title: "title", description: "description", scene: WXSceneTimeline
      end

    end

  end

end
