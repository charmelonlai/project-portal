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

  describe '#add_admin("Add")' do
    before(:each) do
      @admin = FactoryGirl.create(:admin)
      sign_in @admin
      @user = FactoryGirl.create(:user)
      @invalid_email = "blah@gmail.com"
    end
    
    def add_admin_valid
      post :add_admin, {:user => @user.email, :commit => "Add"}
    end
    
    def add_admin_invalid
      post :add_admin, {:user => @invalid_email, :commit => "Add"}
    end
    
    it 'calls create_admin(email)' do
      controller.should_receive(:create_admin).with(@user.email)
      add_admin_valid
    end
    
    it 'redirects to the admin dashboard' do
      add_admin_valid
      expect(response).to redirect_to(admin_dashboard_path)
    end
    
    it 'displays the notice "<name> is now an admin." if the email is valid' do
      add_admin_valid
      expect(flash[:notice]).to eq("#{@user.fname} #{@user.lname} is now an admin.")
    end
    
    it 'displays the error message "<email> does not exist. Would you like to create a user?" if the email is valid' do
      add_admin_invalid
      expect(flash[:error]).to eq("#{@invalid_email} does not exist. Would you like to create a user?")
    end

    it 'displays the notice "<name> is already an admin." if the user is already an admin' do
      post :add_admin, {:user => @admin.email, :commit => "Add"}
      expect(flash[:notice]).to eq("#{@user.fname} #{@user.lname} is already an admin.")
    end
  end
end
