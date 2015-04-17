require 'spec_helper'

describe ProjectsController, type: :controller do

  describe 'Approval/denial:' do

    before(:each) do
      @proj = FactoryGirl.create(:project)
      sign_in FactoryGirl.create(:admin)
      request.env["HTTP_REFERER"] = "where_i_came_from" # http://stackoverflow.com/a/6729817
    end

    describe 'approving a project' do
      it 'sets the approved flag to true' do
        post :approval, { :id => @proj.id, :project => { :approved => "true", :admin_note => "good" } }
        @proj.reload
        expect(@proj.approved).to eq(true)
      end
    end
    
    describe 'denying a project' do
      it 'sets the approved flag to false' do
        post :approval, :id => @proj.id, :project => { :approved => "false", :admin_note => "bad" }
        @proj.reload
        expect(@proj.approved).to eq(false)
      end
    end
    
  end
end
