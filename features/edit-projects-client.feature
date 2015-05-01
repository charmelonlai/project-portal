Feature: Edit client projects
  As non-profit client
  So that I can keep my project information up-to-date
  I want to edit my project

  Background:
  	Given I am logged in as client "Client A"
  	And the following projects exist:
	  | title            | short_description | long_description | client   |
	  | Client A project | short desc A      | long desc A      | Client A |
	  And I am on the "show" page for "Client A project"

  @javascript
  Scenario: Change short description to "blah blah new description"
  	When I edit the short description to be "blah blah new description"
  	Then I should see "blah blah new description"
  	And I should not see "short desc A"
