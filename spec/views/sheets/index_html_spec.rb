require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/sheets" do
  before(:each) do
    @controller,@action = get("/sheets")
    @body = @controller.body
  end

  it "should mention Sheets" do
    @body.should match(/Sheets/)
  end
end