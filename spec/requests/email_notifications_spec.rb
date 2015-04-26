require 'spec_helper'

describe "EmailNotifications", :type => :request do
  describe "GET /email_notifications" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # create client user and login
      user = FactoryGirl.create(:client).user
      post new_user_session_path, "user[email]" => user.email, "user[password]" => user.password

      get email_notifications_path # :index action
      expect(response).to be_success
    end
  end
end
