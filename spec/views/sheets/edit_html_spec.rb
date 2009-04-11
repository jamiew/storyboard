require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/sheets/edit" do
  before(:each) do
    @controller,@action = get("/sheets/edit")
    @body = @controller.body
  end

  it "should mention Sheets" do
    @body.should match(/Sheets/)
  end
end