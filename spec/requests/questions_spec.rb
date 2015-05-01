require 'spec_helper'
require 'pp'

describe "Questions", :type => :request do
  skip "GET /questions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # create org user and sign in
      user = FactoryGirl.create(:organization).user
      post new_user_session_path, "user[email]" => user.email, "user[password]" => user.password

      get questions_path
      expect(response).to be_success
    end
  end
end
