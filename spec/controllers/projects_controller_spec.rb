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
  
  describe '#show' do
    it 'displays the notice "Nonexistent project." when the project id is invalid' do
      get :show, :id => 'gobbledygook'
      expect(flash[:notice]).to eq("Nonexistent project.")
    end
    
    it 'redirects to the index page when the project id is invalid' do
      get :show, :id => 'gobbledygook'
      expect(response).to redirect_to(projects_path)
    end
  end
  
  describe '#edit' do
    it 'prevents a random user from editing a project they don\'t own' do
      sign_in FactoryGirl.create(:client).user
      proj = FactoryGirl.create(:project)
      controller.stub(:user_can_update?).and_return(false)

      get :edit, :id => proj.slug
      expect(flash[:notice]).to eq('You do not have permission to edit this project.')
    end
  end
  
  describe '#permission_to_update' do
    before(:each) do
      @proj = FactoryGirl.create(:project)
      # stub out :user_can_update?
      controller.stub(:user_can_update?).and_return(false)
    end
    
    it 'sets flash if the user does not have permission to modify the project' do
      @proj = FactoryGirl.create(:project)
      # stub out :redirect_to
      controller.stub(:redirect_to).with(@proj).and_return(true)

      controller.send(:permission_to_update, @proj)
      expect(flash[:error]).to eq('You do not have permission to edit this project.')
    end
    
    it 'redirects to the project page if the user does not have permission to modify the project' do
      controller.should_receive(:redirect_to).with(@proj).and_return(true)
      controller.send(:permission_to_update, @proj)
    end
  end
  
  describe '#org_questions' do
    before(:each) do
      sign_in FactoryGirl.create(:client).user
      request.env["HTTP_REFERER"] = "where_i_came_from" # http://stackoverflow.com/a/6729817
      controller.stub(:check_proposal_window) # make portal open to new proposals
    end
    
    def post_to_org_questions
      post :org_questions, :project => {:title => "my title", :sector => "Animals", :project_type => "Database", :organizations => {:blueprint => "1"}}
    end
    
    it 'sets session[:org] to ...' do
      post_to_org_questions
      expect(session[:org]).to eq({"blueprint" => "1"})
    end
    
    it 'sets session[:proj] to ...' do
      post_to_org_questions
      expect(session[:proj]).to eq({"title" => "my title", "sector" => "Animals", "project_type" => "Database"})
    end
    
    it 'renders the template "org_questions"' do
      post_to_org_questions
      expect(response). to render_template(:org_questions)
    end
  end
  
  describe '#create' do
    before(:each) do
      sign_in FactoryGirl.create(:client).user
      request.env["HTTP_REFERER"] = "where_i_came_from" # http://stackoverflow.com/a/6729817
      controller.stub(:check_proposal_window) # make portal open to new proposals
      
      # setup questions
      Question.delete_all
      FactoryGirl.create(:question, :question => "q1")
      FactoryGirl.create(:question, :question => "q2")
      FactoryGirl.create(:question, :question => "q3")
      
      # setup session
      @title = "my title"
      session[:org] = {"blueprint" => "1"}
      session[:proj] = {"title" => @title, "sector" => "Animals", "project_type" => "Database"}
    end
    
    def post_to_create
      post :create, :project => {:problem => "my problem", :short_description => "my short desc", :long_description => "my long desc", :questions => {"question_1" => "no", "question_2" => "yes", "question_3" => "yes"}}
    end
    
    it 'displays the notice "Project was successfully created."' do
      post_to_create
      expect(flash[:notice]).to eq('Project was successfully created.')
    end
    
    it 'redirects to the "show" page for the project' do
      post_to_create
      expect(response).to redirect_to(Project.find_by_title(@title))
    end
    
    it 'renders the "new" template if the project could not be saved' do
      Project.any_instance.stub(:update_attributes).and_return(false)
      post_to_create
      expect(response).to render_template(:new)
    end
  end
  
  describe '#update' do
    before(:each) do
      sign_in FactoryGirl.create(:admin)
      @proj = FactoryGirl.create(:project)
    end
    
    def post_to_update
      post :update, { :id => @proj.slug, :project => {:title => 'New Title'} }
    end
    
    it 'displays the notice "Project was successfully updated."' do
      Project.any_instance.stub(:update_attributes).and_return(true)
      post_to_update
      expect(flash[:notice]).to eq('Project was successfully updated.')
    end
    
    it 'redirects to the "show" page for the project' do
      Project.any_instance.stub(:update_attributes).and_return(true)
      post_to_update
      expect(response).to redirect_to(@proj)
    end
    
    it 'renders the "edit" template if the project could not be updated' do
      Project.any_instance.stub(:update_attributes).and_return(false)
      post_to_update
      expect(response).to render_template(:edit)
    end
  end
end
