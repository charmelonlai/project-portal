Given(/^I am logged in as client "(.*?)"$/) do |name|
	#create nonprofit client account
	nonprofit_user = User.create({
    fname: "Nonprofit",
    lname: "User",
    admin: false,
    email: "client@admin.com",
    password: "password"
    })
  nonprofit_user.confirmed_at = Time.now
  nonprofit_user.save!

  nonprofit_client = Client.create({
    company_name: name,
    company_site:'http://www.nonprofit.com',
    company_address: '102 Nonprofit Hall',
    nonprofit: true,
    five_01c3: true,
    mission_statement: 'Nonprofit.',
    contact_email: 'client@admin.com',
    contact_number: 'N/A'
  })

  nonprofit_user.rolable = nonprofit_client
  nonprofit_user.rolable_type = nonprofit_client.class.name
  nonprofit_user.save!

	#login
	visit new_user_session_path
  fill_in 'user_email', :with => 'client@admin.com'
  fill_in 'user_password', :with => 'password'
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
	
  project = Project.create({
    title: "title",
    github_site: "https://github.com/callmemc/altbreaks",
    application_site: "http://publicservice.berkeley.edu/alternativebreaks",
    short_description: "short description",
    long_description: "long description",
    problem: "problem"
  })
  project.client = Client.find_by_company_name(name)
  project.project_type = type
  project.sector = focus
  project.save!
end

Given /I am on the client dashboard$/ do
	visit dashboard_path
end

