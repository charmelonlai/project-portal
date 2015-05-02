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

  describe '#add_admin("View All")' do
    before(:each) do
      @admin = FactoryGirl.create(:admin)
      
      @admins = []
      @admins << @admin
    end
    
    def add_admins(n)
      admins = (1..n).map { |x| FactoryGirl.create(:admin, :fname => "fname#{rand(1000)}", :lname => "lname#{rand(1000)}") }
      @admins.push(*admins)
    end
    
    def view_all
      post :add_admin, {:commit => "View All"}
    end
    
    describe 'if the user is logged in as an admin, ' do
      before(:each) do
        sign_in @admin
      end
      
      it 'calls view_all_admins' do
        controller.should_receive(:view_all_admins)
        view_all
      end

      it 'renders the template "user/add_admin"' do
        view_all
        expect(response).to render_template("user/add_admin")
      end
      
      it 'displays the names of all the admins' do
        view_all
        @admins.each do |admin|
          expect(response.body).to include("#{admin.fname} #{admin.lname}")
        end
      end
      
      it 'displays the emails of all the admins' do
        view_all
        @admins.each do |admin|
          expect(response.body).to include(admin.email)
        end
      end
    end

    describe 'if the user is logged in as a client, ' do
      before(:each) do
        sign_in FactoryGirl.create(:client).user
      end

      it 'displays the error message "You do not have the right permissions to view this page." if the email is valid' do
        view_all
        expect(flash[:notice]).to eq("You do not have the right permissions to view this page.")
      end
      
      it 'redirects to the dashboard' do
        view_all
        expect(response).to redirect_to(dashboard_path)
      end
    end
    
    describe 'if the user is not logged in, ' do
      it 'displays the error message "Please log in." if the email is valid' do
        view_all
        expect(flash[:notice]).to eq("Please log in.")
      end
      
      it 'redirects to the login page' do
        view_all
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  
  describe '#remove_admin' do
    before(:each) do
      @admin = FactoryGirl.create(:admin)
      
      @admins = []
      @admins << @admin
      @admins.push(*create_admins(5))
      @admin_to_remove = @admins[2]
    end
    
    def create_admins(n)
      (1..n).map { |x| FactoryGirl.create(:admin, :fname => "fname#{rand(1000)}", :lname => "lname#{rand(1000)}") }
    end
    
    def remove_admin(id)
      post :remove_admin, :id => id
    end
    
    describe 'if the user is logged in as an admin,' do
      before(:each) do
        sign_in @admin
      end
      
      describe 'and the id is valid,' do
        it 'redirects to the add admin page' do
          remove_admin(@admin_to_remove.id)
          expect(response).to redirect_to(add_admin_path)
        end
        
        it 'displays the notice "<name> is no longer an admin."' do
          remove_admin(@admin_to_remove.id)
          expect(flash[:notice]).to eq("#{@admin_to_remove.fname} #{@admin_to_remove.lname} is no longer an admin.")
        end
      end
      
      describe 'and the id is invalid,' do
        it 'redirects to the settings page' do
          remove_admin(500)
          expect(response).to redirect_to(user_settings_path)
        end
        
        it 'displays the error message "Your action is invalid."' do
          remove_admin(500)
          expect(flash[:error]).to eq("Your action is invalid.")
        end
      end
    end

    describe 'if the user is logged in as a client,' do
      before(:each) do
        sign_in FactoryGirl.create(:client).user
      end

      it 'displays the notice "You do not have the right permissions to view this page."' do
        remove_admin(@admin_to_remove.id)
        expect(flash[:notice]).to eq("You do not have the right permissions to view this page.")
      end
      
      it 'redirects to the dashboard' do
        remove_admin(@admin_to_remove.id)
        expect(response).to redirect_to(dashboard_path)
      end
    end
    
    describe 'if the user is not logged in,' do
      it 'displays the notice "Please log in."' do
        remove_admin(@admin_to_remove.id)
        expect(flash[:notice]).to eq("Please log in.")
      end
      
      it 'redirects to the login page' do
        remove_admin(@admin_to_remove.id)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
