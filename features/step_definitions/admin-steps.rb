require 'uri'
require 'cgi'

# login as admin
Given /I am logged in as an administrator/ do
  admin = FactoryGirl.create(:admin)

  # login
  visit new_user_session_path
  fill_in 'user_email', :with => admin.email
  fill_in 'user_password', :with => admin.password
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
end

# set up approved/denied condition
Given /^"(.*)" is currently (.*)$/ do |proj, status|
  project = Project.find_by_title(proj)
  project.update_attribute(:approved, status == 'approved')
  visit project_path(proj)
  page.should have_content("Project has been #{status}")
end

When /^(?:|I )press "([^"]*)"(?: within "(.*)")?$/ do |button, parent|
  if parent
    within(parent) { click_button(button) }
  else
    click_button(button)
  end
end

When /^I click "(.*)"$/ do |link|
  click_link(link)
end

When /^I fill in "(.*)" with "([^"]*)"(?: within "(.*)")?$/ do |field, value, parent|
  if parent
    within(parent) { fill_in(field, :with => value) }
  else
    fill_in(field, :with => value)
  end
end

Then /^(?:|I )should be on the "show" page for "(.*)"$/ do |proj|
  current_path = URI.parse(current_url).path
  current_path.should == project_path(proj)
end

Then /^I should see "([^"]*)"(?: within "(.*)")?$/ do |text, parent|
  if parent
    within(parent) { page.should have_content(text) }
  else
    page.should have_content(text)
  end
end

Then /^I should see a link "(.*)" to "(.*)"$/ do |link, url|
  page.should have_link(link, :href => url)
end

# check that an email was sent (http://stackoverflow.com/a/15754349)
Then /^the client of "(.*)" should be sent a notification email about the (approval|decline)$/ do |proj, status|
  project = Project.find_by_title(proj)
  client = Client.find(project.client_id).user
  email = ActionMailer::Base.deliveries.last
  email[:from].to_s.should == "support@projectportal.com"
  email[:to].to_s.should == client.email
  email.subject.should == ((status == 'approval') ? "[Project Portal] Your project has been approved!" : "[Project Portal] Project follow-up")
  email.body.should include("Dear #{client.fname}")
end

Given(/^I am on the admin dashboard$/) do
  visit admin_dashboard_path
end
