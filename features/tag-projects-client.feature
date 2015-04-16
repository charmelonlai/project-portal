Feature: Classify client projects
  As non-profit client
  So that I can find interested and invested developers
  I want to be able to classify my proposal by industry and project type

  Background:
  	Given I am logged in as client "American Red Cross"

  Scenario: Should see fields for focus and type
  	Given I am on the new project page
  	Then I should see a field with the label "Project Focus"
  	And I should see a field with the label "Project Type"

  Scenario: Should see tags for focus and type
  	Given American Red Cross creates a project with a focus of "Animals" and a type of "Mobile"
  	And I am on the client dashboard
  	Then I should see "Animals"
  	And I should see "Mobile"