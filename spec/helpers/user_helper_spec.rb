require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ProjectStepsHelper. For example:
#
# describe ProjectStepsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe UserHelper, :type => :helper do

  before(:each) do
    @client_user_id = FactoryGirl.create(:client).user.id
    @developer_user_id = FactoryGirl.create(:developer)
    @organization_user_id = FactoryGirl.create(:organization).user.id
  end

  describe "is_client?" do
    it "returns true if the user id is of a client user" do
      expect(is_client?(@client_user_id)).to be true
    end
    
    it "returns false if the user id is not of a client user" do
      expect(is_client?(@developer_user_id)).to be false
      expect(is_client?(@organization_user_id)).to be false
    end
  end

  describe "is_developer?" do
    it "returns true if the user id is of a developer" do
      expect(is_developer?(@developer_user_id)).to be true
    end
    
    it "returns false if the user id is not of a developer" do
      expect(is_developer?(@client_user_id)).to be false
      expect(is_developer?(@organization_user_id)).to be false
    end
  end

  describe "is_organization?" do
    it "returns true if the user id is of an organization user" do
      expect(is_organization?(@organization_user_id)).to be true
    end
    
    it "returns false if the user id is not of a client user" do
      expect(is_organization?(@client_user_id)).to be false
      expect(is_organization?(@developer_user_id)).to be false
    end
  end
end
