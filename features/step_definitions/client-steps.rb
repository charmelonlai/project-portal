Given(/^I (?:am logged in|login) as client "(.*?)"$/) do |name|
	# create nonprofit client account
	client = FactoryGirl.create(:client, :company_name => name)

  # logout of current session if needed
  if @current_user
    click_link "Logout"
    @current_user = client.user
  end

	# login
	visit new_user_session_path
  fill_in 'user_email', :with => client.user.email
  fill_in 'user_password', :with => client.user.password
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
end

Given /^I am on the new project page$/ do
	visit new_project_path
end

Then /^I should see a field with the label "(.*?)"$/ do |label|
	page.has_field?(label).should == true
end

Given /^(.*?) creates a project with a focus of "(.*?)" and a type of "(.*?)"$/ do |name, focus, type|
  project = FactoryGirl.create(:project, :client => Client.find_by_company_name(name), :project_type => type, :sector => focus)
end

Given /^I am on the client dashboard$/ do
	visit dashboard_path
end

Given /^the application is currently open \(client\)$/ do
  # assume we are logged in as a client
  Rails.application.config.end_date = Date.new(Date.today.year + 5, 1, 1)
end

Then /^the link "(.*?)" should have a not\-allowed style and have no href attribute\.$/ do |name|
  link = page.find('a', :text => name)
  expect(link[:class]).to eq('noproposals')
  expect(link[:href]).to eq(nil)
end

Then /^the link "(.*?)" should link to the new projects page\.$/ do |name|
  link = page.find('a', :text => name)
  expect(link[:class].gsub(/\s+/, "")).to eq('')
  expect(link[:href]).to eq(new_project_path)
end
