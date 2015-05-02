require 'spec_helper'

describe UserController, type: :controller do
  render_views
  
  describe '#dashboard' do
    before(:each) do
      sign_in FactoryGirl.create(:organization).user
    end
    
    it 'renders the template "user/organization_dashboard" if an organization is logged in' do
      get :dashboard
      expect(response).to render_template('user/organization_dashboard')
    end
  end
end
