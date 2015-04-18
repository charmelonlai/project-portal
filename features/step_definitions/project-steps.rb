# create a project
Given /a project called "(.*)" exists(?:, with short description "(.*)")?/ do |title, desc|
  # @proj = FactoryGirl.create(:project, :title => title, :short_description => desc, :approved => false)
  # from db/seeds.rb
  cs169 = Organization.create({
    sname: 'cs169',
    name: "UC Berkeley CS169 Software Engineering Course",
    description: "Over the course of a semester, students complete a course project in teams of four or five. Groups will be assigned to an external customer from a campus or non-profit organization to build a SaaS application.",
    website: "https://sites.google.com/site/ucbsaas/",
  })

  cs169_questions = Question.create([
    { question: "If selected, is the contact listed above available to speak on a weekly basis with a student from CS169?",
      input_type: "boolean"
    },
    { question: "If selected, will you and your organization fully commit to an engagement with CS169 for 8 weeks in Spring 2014?",
      input_type: "boolean"
    },
    { question: "Does the contact above have the ability to implement software solutions developed by the CS169 team?",
      input_type: "boolean"
    },
    { question: "Is this a software project?",
      input_type: "boolean"
    }
  ])
  cs169.questions << cs169_questions

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
    company_name: 'My Nonprofit',
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

  project = Project.create({
    title: title,
    github_site: "https://github.com/callmemc/altbreaks",
    application_site: "http://publicservice.berkeley.edu/alternativebreaks",
    short_description: desc.nil? ? "short description" : desc,
    long_description: "We want an interactive map to show all the trips, so that if you hover over a trip location, a pop-up is displayed with the trip information. We also want trip pages. And we want an internal forum where people from trips can communicate with each other and with people from other trips.",
    problem: "Solve communication issues internally within and between different break groups, as well as externally in creating a beautiful site that will increase our reputation and attract more applicants."
  })
  project.client = nonprofit_client
  project.organizations << cs169
  project.questions = {'question_1' => true, 'question_2' => true, 'question_3' => true}
  project.project_type = "Design"
  project.sector = "Technology"
  project.approved = false
  project.save!
  
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

    if organization
      org = Organization.find_by_sname(organization)
      project.organizations << org
    end
    
  end
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should !have_content(text)
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
