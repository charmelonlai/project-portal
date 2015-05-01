require "spec_helper"

describe EmailNotificationsController, :type => :routing do
  describe "routing" do

    it "routes to #update" do
      expect(put("/email_notifications/1/edit")).to route_to("email_notifications#update", :id => "1")
    end

  end
end
