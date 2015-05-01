Given /^an organization called "(.*?)" exists with questions "(.*?)" and "(.*?)"$/ do |sname, q1, q2|
  organization = FactoryGirl.create(:organization, :sname => sname, :name => sname)
  question1 = FactoryGirl.create(:question, :question => q1)
  question2 = FactoryGirl.create(:question, :question => q2)
  organization.questions = [question1, question2]
end

Given /I am logged in as an organization/ do
  # create organization account
  organization = FactoryGirl.create(:organization)

  #login
  visit new_user_session_path
  fill_in 'user_email', :with => organization.user.email
  fill_in 'user_password', :with => organization.user.password
  click_button 'Sign in'
  page.should have_content('Signed in successfully')
  
  @current_user = organization.user
end

And /I am on the organization dashboard$/ do
  visit dashboard_path
end

When /I select "(.*?)" from "(.*?)"$/ do |option, field|
  select option, :from => field
end

When /I submit the filter form$/ do
  click_button("Go")
end
