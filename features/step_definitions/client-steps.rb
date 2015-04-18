Given(/^I (?:am logged in|login) as client "(.*?)"$/) do |name|
	# create nonprofit client account
	client = FactoryGirl.create(:client, :company_name => name)

	# login
	visit new_user_session_path
  fill_in 'user_email', :with => client.user.email
  fill_in 'user_password', :with => client.user.password
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
end

Given /I am on the new project page$/ do
	visit new_project_path
end

Then /I should see a field with the label "(.*?)"$/ do |label|
	page.has_field?(label).should == true
end

Given /(.*?) creates a project with a focus of "(.*?)" and a type of "(.*?)"$/ do |name, focus, type|
  project = FactoryGirl.create(:project, :client => Client.find_by_company_name(name), :project_type => type, :sector => focus)
end

Given /I am on the client dashboard$/ do
	visit dashboard_path
end
