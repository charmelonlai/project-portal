require 'spec_helper'

describe ApplicationController, :type => :controller do

  describe '#is_admin' do
    before(:each) do
      @client_user = FactoryGirl.create(:client).user
      @organization_user = FactoryGirl.create(:organization).user
      @admin = FactoryGirl.create(:admin)
    end
  
    it 'returns true when an admin is signed in' do
      sign_in @admin
      expect(controller.is_admin).to be true
    end
    
    it 'returns false when a client is signed in' do
      sign_in @client_user
      expect(controller.is_admin).to be false
    end
    
    it 'returns false when an organization is signed in' do
      sign_in @organization_user
      expect(controller.is_admin).to be false
    end
  end

  describe '#current_rolable_type' do
    before(:each) do
      @client_user = FactoryGirl.create(:client).user
      @organization_user = FactoryGirl.create(:organization).user
    end
    
    it 'returns "client" when a client is signed in' do
      sign_in @client_user
      expect(controller.current_rolable_type).to eq("Client")
    end
    
    it 'returns "organization" when an organization is signed in' do
      sign_in @organization_user
      expect(controller.current_rolable_type).to eq("Organization")
    end
  end

end
