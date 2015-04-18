require 'spec_helper'

describe ProjectsController, type: :controller do

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
end
