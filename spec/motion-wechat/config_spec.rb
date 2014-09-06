describe MotionWechat::Config do

  it "has correct info plist key" do
    MotionWechat::Config.info_plist_key.should == 'WechatConfig'
  end

end
