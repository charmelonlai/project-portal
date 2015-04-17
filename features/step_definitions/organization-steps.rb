Given /I am logged in as an organization/ do
  # create organization account
  organization_user = User.create({
    fname:  "Organization",
    lname: "User",
    admin: false,
    email: "organization@admin.com",
    password: "password"
  })
  organization_user.confirmed_at = Time.now
  organization_user.save!

  organization = Organization.create({
    sname: "CS169",
    name: "UC Berkeley CS169 Software Engineering",
    description: "description",
    website: "http://cs169.edu/"
  })

  organization_user.rolable = organization
  organization_user.rolable_type = organization.class.name
  organization_user.save!

  #login
  visit new_user_session_path
  fill_in 'user_email', :with => 'organization@admin.com'
  fill_in 'user_password', :with => 'password'
  click_button 'Sign in'
  page.should have_content('Signed in successfully')  
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