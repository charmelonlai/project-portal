require 'spec_helper'

describe "EmailNotifications", :type => :controller do
  describe "GET /email_notifications" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      @controller = EmailNotificationsController.new
      get :index
      response.status.should be(200)
    end
  end
end
