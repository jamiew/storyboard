require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/games" do
  before(:each) do
    @controller,@action = get("/games")
    @body = @controller.body
  end

  it "should mention Games" do
    @body.should match(/Games/)
  end
end