Feature: Classify client projects
  As a student developer
  So that I can find projects I am interested in
  I want to be able to filter all available projects by focus and type

  Background:
  	Given the following clients exist:
    | company_name | company_site       | company_address | contact_email      | contact_number |
    | Client A     | http://clienta.org | 123 Client A Dr | client@clienta.org | N/A            |
    | Client B     | http://clientb.org | 123 Client B Dr | client@clientb.org | (408)-254-3682 |
    | Client C     | http://clientc.org | 123 Client C Dr | client@clientc.org | (408)-254-3683 |
    And the following public projects exist:
    | title            | short_description | long_description | client   |	project_type	|	sector		|	organization	|
    | Client A project | short desc A      | long desc A      | Client A |	Design			|	Health		|	CS169			|
    | Client B project | short desc B      | long desc B      | Client B |	Design			|	Animals		|	CS169			|
    | Client C project | short desc C      | long desc C      | Client C |	Mobile			|	Community	|	CS169			|
    And I am on the projects page

  Scenario: Filter by project type
  	When I select "Design" from "project_type"
  	And I submit the filter form
  	Then I should see "Client A project"
  	And I should see "Client B project"
  	But I should not see "Client C project"

  Scenario: Filter by sector
  	When I select "Community" from "project_focus"
  	And I submit the filter form
  	Then I should see "Client C project"
  	But I should not see "Client A project"
  	And I should not see "Client B project"

  Scenario: Filter by both
  	When I select "Design" from "project_type"
  	And I select "Animals" from "project_focus"
  	And I submit the filter form
  	Then I should see "Client B project"
  	But I should not see "Client A project"
  	And I should not see "Client C project"

  Scenario: Reset
  	When I select "Mobile" from "project_type"
  	And I select "Animals" from "project_focus"
  	And I submit the filter form
  	When I click "Reset"
  	Then I should see "Client A project"
  	And I should see "Client B project"
  	And I should see "Client C project"

  Scenario: No projects found
  	When I select "Design" from "project_type"
  	And I select "Community" from "project_focus"
  	And I submit the filter form
  	Then I should not see "Client A project"
  	And I should not see "Client B project"
  	And I should not see "Client C project"
  	And I should see "No publicly available projects yet."
