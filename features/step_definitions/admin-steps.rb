require 'uri'
require 'cgi'

# login as admin
Given /I am logged in as an administrator/ do
  admin = FactoryGirl.create(:admin)
  @current_user = admin

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
  regexp = Regexp.new(text, "i")
  if parent
    within(parent) { expect(page.text).to match(regexp) }
  else
    expect(page.text).to match(regexp)
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

Given(/^I (?:am|should be) on the admin dashboard$/) do
  visit admin_dashboard_path
end

Given /^the application is currently open \(admin\)$/ do
  # assume we are already on the admin dashboard
  page.select((Date.today.year + 5).to_s, :from => 'dates[end_date(1i)]')
  click_button('Set Date')
end

Given /^the application is currently closed$/ do
  # assume we are already on the admin dashboard
  page.select((Date.today.year - 5).to_s, :from => 'dates[end_date(1i)]')
  click_button('Set Date')
end

When /^I set the proposal deadline to a past date$/ do
  step "the application is currently closed"
end

When /^I set the proposal deadline to a future date$/ do
  step "the application is currently open \(admin\)"
end

When /^I set the proposal deadline to an invalid date$/ do
  page.select('February', :from => 'dates[end_date(2i)]')
  page.select('31', :from => 'dates[end_date(3i)]')
  click_button('Set Date')
end
