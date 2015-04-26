require "spec_helper"

describe EmailNotificationsController, :type => :routing do
  describe "routing" do

    it "routes to #edit" do
      get("/email_notifications/1/edit").should route_to("email_notifications#edit", :id => "1")
    end

    it "routes to #update" do
      put("/email_notifications/1/edit").should route_to("email_notifications#update", :id => "1")
    end

  end
end
