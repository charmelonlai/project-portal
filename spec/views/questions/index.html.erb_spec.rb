require 'spec_helper'

describe "questions/index", :type => :view do
  before(:each) do
    assign(:questions, [
      stub_model(Question),
      stub_model(Question)
    ])
  end

  skip "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
