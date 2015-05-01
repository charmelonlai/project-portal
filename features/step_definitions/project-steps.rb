# create a project
Given /a project called "(.*)" exists(?:, with short description "(.*)")?/ do |title, desc|
  proj = FactoryGirl.create(:project, :title => title, :short_description => desc, :approved => false)
  
  # verify that the project shows on the admin dashboard
  visit admin_dashboard_path
  page.should have_content(title)
end

Given /^the following clients exist:$/ do |table|
  table.hashes.each do |hash|
    nonprofit_client = FactoryGirl.create(:client, hash)
  end
end

Given /^the following projects exist:$/ do |table|
  table.hashes.each do |hash|
    hash['client'] = Client.find_by_company_name(hash['client'])
    organization = hash.delete('organization')
    project = FactoryGirl.create(:project, hash)
    @proj = project

    if organization
      org = Organization.find_by_sname(organization)
      project.organizations << org
    end
    
  end
end

Given /^the following questions exist:$/ do |table|
  @questions = []
  table.hashes.each do |hash|
    @questions << FactoryGirl.create(:question, hash)
  end
end

Given /^the answers for the project are "(.*?)" and "(.*?)"$/ do |a1, a2|
  q1 = @questions[0]
  q2 = @questions[1]
  @proj.questions = {"question_#{q1.id}" => a1, "question_#{q2.id}" => a2}
  @proj.save!
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should have_no_content(text)
end

# http://stackoverflow.com/a/6533829
Then /^I should get a download with the filename "([^\"]*)"$/ do |filename|
  page.response_headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end

# http://collectiveidea.com/blog/archives/2012/01/27/testing-file-downloads-with-capybara-and-chromedriver/
Then "the downloaded file content should be:" do |content|
  page.source.should == content
end

Then /^I should see "([^\/]*)" (.+) times$/ do |regexp, times|
  str = regexp
  times = times.to_i
  for i in 1..(times - 1)
    str = str + "(.+)" + regexp
  end
  regexp = Regexp.new(str)
  expect(page).to have_content(regexp)
end

Given(/^I visit the "show" page for "(.*?)"$/) do |proj|
  visit project_path(proj)
  expect(page).to have_content('Project Purpose')
  expect(page).to have_content('Brief Description')
  expect(page).to have_content('Specifics')
end

Given(/^"(.*?)" is approved$/) do |proj_title|
  proj = Project.find_by_title(proj_title)
  proj.approved = true
end

Given(/^"(.*?)" is denied$/) do |proj_title|
  proj = Project.find_by_title(proj_title)
  proj.approved = false
end

Given(/^I should see "(.*?)" before "(.*?)"$/) do |proj1, proj2|
  str = proj1 + "(.+)" + proj2
  regexp = Regexp.new(str)
  expect(page).to have_content(regexp)
end

Then /^I pause for a while$/ do
  sleep 30
end

Then /^the "(.*?)" (button|pane) should be active$/ do |id, button_or_pane|
  find("#" << id)['class'].should include("active")
end

Then /^the "(.*?)" (button|pane) should not be active$/ do |id, button_or_pane|
  find("#" << id)['class'].should !include("active")
end

And(/^"(.*?)" should not be visible$/) do |text|
  assert page.body.should !include(text)
end

And(/^I click on the "(.*?)" button$/) do |id|
  click_link(id)
end
