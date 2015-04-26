require 'spec_helper'

describe "EmailNotifications", :type => :request do
  describe "PUT /email_notifications/1/edit" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # create client user and login
      user = FactoryGirl.create(:client).user
      post new_user_session_path, "user[email]" => user.email, "user[password]" => user.password

      subject { put update_email_notification_path(user.id), "email_notification[proj_approval]" => "false" }

      expect(subject).to redirect_to(dashboard_path)
    end
  end
end
