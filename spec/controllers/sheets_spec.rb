require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Sheets Controller", "index action" do
  before(:each) do
    @controller = Sheets.build(fake_request)
    @controller.dispatch('index')
  end
end