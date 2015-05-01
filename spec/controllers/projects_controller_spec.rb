require 'spec_helper'

describe ProjectsController, type: :controller do
  render_views

  describe 'Approval/denial:' do

    before(:each) do
      @proj = FactoryGirl.create(:project)
      sign_in FactoryGirl.create(:admin)
      request.env["HTTP_REFERER"] = "where_i_came_from" # http://stackoverflow.com/a/6729817
    end

    describe 'approving a project' do
      def approve_proj
        post :approval, :id => @proj.id, :project => { :approved => "true", :admin_note => "good" }
      end
    
      it 'sets the approved flag to true' do
        approve_proj
        @proj.reload
        expect(@proj.approved).to eq(true)
      end
      
      it 'calls ProjectsController#approve_deny_project' do
        expect(controller).to receive(:approve_deny_project).with(@proj)
        approve_proj
      end
      
      it 'should redirect to where_i_came_from' do
        approve_proj
        expect(response).to redirect_to('where_i_came_from')
      end
    end
    
    describe 'denying a project' do
      def deny_proj
        post :approval, :id => @proj.id, :project => { :approved => "false", :admin_note => "bad" }
      end
      
      it 'sets the approved flag to false' do
        deny_proj
        @proj.reload
        expect(@proj.approved).to eq(false)
      end
      
      it 'calls ProjectsController#approve_deny_project' do
        expect(controller).to receive(:approve_deny_project).with(@proj)
        deny_proj
      end
      
      it 'should redirect to where_i_came_from' do
        deny_proj
        expect(response).to redirect_to('where_i_came_from')
      end
    end
    
  end
  
  describe '#get_user_id_from_email' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
  
    it 'works' do
      got = controller.send(:get_user_id_from_email, @user.email)
      expect(got).to eq(@user.id)
    end
    
    it 'returns nil if no user has that email' do
      got = controller.send(:get_user_id_from_email, "blah@gmail.com")
      expect(got).to eq(nil)
    end
  end
  
  describe '#search' do
    
    def create_public_projects_with_word(n, word)
      (1..n).map { |x| FactoryGirl.create(:project, :title => "a#{rand(2000)}#{word}#{rand(2000)}a", :organizations => []) }
    end
  
    it 'displays all project whose title contains "health"' do
      projects = create_public_projects_with_word(3, "health")
      get :search, :search_string => "health"
      
      projects.each do |proj|
        expect(response.body).to include(proj.title)
      end
    end
  end
  
  describe '#index' do
    
    def create_public_projects(n)
      (1..n).map { |x| FactoryGirl.create(:project, :organizations => []) }
    end
  
    it 'displays all public projects' do
      projects = create_public_projects(5)
      get :index
      
      projects.each do |proj|
        expect(response.body).to include(proj.title)
      end
    end
  end
  
  describe '#edit' do
    it 'prevents a random user from editing a project they don\'t own' do
      sign_in FactoryGirl.create(:client).user
      @proj = FactoryGirl.create(:project)
      controller.stub(:user_can_update?).and_return(false)

      get :edit, :id => @proj.slug
      expect(flash[:notice]).to eq('You do not have permission to edit this project.')
    end
  end
end
