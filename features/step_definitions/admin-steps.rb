require 'uri'
require 'cgi'

# login as admin
Given /I am logged in as an administrator/ do
  # create admin account (from db/seeds.rb)
  u = User.create({
    fname: "Admin",
    lname: "Admin",
    admin: true,
    email: "admin@admin.com",
    password: "password"
  })
  u.confirmed_at = Time.now
  u.save

  # login
  visit new_user_session_path
  fill_in 'user_email', :with => 'admin@admin.com'
  fill_in 'user_password', :with => 'password'
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
end

Given(/^I visit the "show" page for "(.*?)"$/) do |proj|
  visit project_path(proj)
  page.should have_content('Project Purpose')
  page.should have_content('Brief Description')
  page.should have_content('Specifics')
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
  client = User.where("rolable_id = #{project.client_id} and rolable_type = 'Client'").first!
  email = ActionMailer::Base.deliveries.last
  email[:from].to_s.should == "support@projectportal.com"
  email[:to].to_s.should == client.email
  email.subject.should == ((status == 'approval') ? "[Project Portal] Your project has been approved!" : "[Project Portal] There were some issues with your project.")
  email.body.should include("Dear #{client.fname} #{client.lname}")
end

Given(/^I am on the admin dashboard$/) do
  visit '/dashboard'
end
