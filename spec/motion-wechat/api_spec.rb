describe MotionWechat::API do

  before { @mv = MotionWechat::API.instance }

  it "should call register key" do
    WXApi.stub!(:registerApp) do |key|
      key.should == "app_key"
    end
    @mv.register
  end

  describe "Send messages" do

    before { @mv.register }

    it 'sends web page url' do
      WXApi.stub!(:sendReq) do |req|
        req.should.be.kind_of(SendMessageToWXReq)
        req.message.should.be.kind_of(WXMediaMessage)
        req.message.mediaObject.should.be.kind_of(WXWebpageObject)
        req.message.mediaObject.webpageUrl.should == "http://www.motion-wechat.com"
      end

      MotionWechat::API.instance.send_webpage "http://www.motion-wechat.com", \
        title: "title", description: "description"
    end

    it 'sends video url' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXVideoObject)
        req.message.mediaObject.videoUrl.should == "http://www.youtube.com/1"
      end

      MotionWechat::API.instance.send_video "http://www.youtube.com/1", \
        title: "title", description: "description"
    end

    it 'sends music url' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXMusicObject)
        req.message.mediaObject.musicUrl.should == "http://www.pandora.com/1"
      end

      MotionWechat::API.instance.send_music "http://www.pandora.com/1", \
        title: "title", description: "description"
    end

    it 'sends image' do
      WXApi.stub!(:sendReq) do |req|
        req.message.mediaObject.should.be.kind_of(WXImageObject)
      end

      MotionWechat::API.instance.send_image NSData.dataWithContentsOfFile("dummy"), \
        title: "title", description: "description"
    end

    it 'sends text' do
      WXApi.stub!(:sendReq) do |req|
        req.should.be.kind_of(SendMessageToWXReq)
        req.text.should == "hello"
      end

      MotionWechat::API.instance.send_text "hello"
    end

    describe "Scene type" do

      it "default sends to session" do
        WXApi.stub!(:sendReq) do |req|
          req.should.be.kind_of(SendMessageToWXReq)
          req.scene.should == WXSceneSession
        end

        MotionWechat::API.instance.send_webpage "http://www.motion-wechat.com", \
          title: "title", description: "description"
      end

      it "sends to time line" do
        WXApi.stub!(:sendReq) do |req|
          req.should.be.kind_of(SendMessageToWXReq)
          req.scene.should == WXSceneTimeline
        end

        MotionWechat::API.instance.send_webpage "http://www.motion-wechat.com", \
          title: "title", description: "description", scene: WXSceneTimeline
      end

    end

  end

end
