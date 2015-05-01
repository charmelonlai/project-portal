Feature: Edit client projects
  As non-profit client
  So that I can keep my project information up-to-date
  I want to edit my project

  Background:
  	Given I am logged in as client "Client A"
  	And the following projects exist:
	  | title            | short_description | long_description | client   |
	  | Client A project | short desc A      | long desc A      | Client A |
	  And the following questions exist:
	  | question | input_type |
    | q1?      | boolean    |
    | q2?      | boolean    |
    And the answers for the project are "yes" and "yes"
	  And I am on the "show" page for "Client A project"

  @javascript
  Scenario: Change short description to "blah blah new description"
  	When I edit the short description to be "blah blah new description"
  	Then I should see "blah blah new description"
  	And I should not see "short desc A"
  	
  @javascript
  Scenario: Change the answer for a question to "no"
  	When I edit the answer for the second question to be "no"
  	Then I should see "q2\?: no"
  	And I should not see "q2\?: yes"
