require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Games Controller", "index action" do
  before(:each) do
    @controller = Games.build(fake_request)
    @controller.dispatch('index')
  end
end