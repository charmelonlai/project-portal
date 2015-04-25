Feature: display project page view properly
	As an user of the app
	so that I can see the available projects
	I want to make sure that the projects are displayed properly

	Background: 
	  Given I am logged in as an administrator
	  And the following clients exist:
	  | company_name | company_site       | company_address | contact_email      | contact_number |
	  | Client A     | http://clienta.org | 123 Client A Dr | client@clienta.org | N/A            |

	  And the following projects exist:
	  | title            | short_description | long_description | client   |
	  | Client A project | short desc A      | long desc A      | Client A |
	
	Scenario: Should see compact view by default
		Given I am on the admin dashboard
		Then the "compact-proj-btn" button should be active
		And the "compact-proj-view" pane should be active
		And the "square-proj-btn" button should not be active
		And the "square-proj-view" pane should not be active

	Scenario: Should see limited information in list view
		Given I am on the admin dashboard
		Then I should see "Client A project"
		And I should see "Client A"
		And I should see "short desc A"
		And "long desc A" should not be visible

	Scenario: Clicking square view should render square/card view
		Given I am on the admin dashboard
		And I click on the "square-proj-btn" button
		Then the "compact-proj-btn" button should not be active
		And the "compact-proj-view" pane should not be active
		#And the "square-proj-btn" button should be active
		#And the "square-proj-view" pane should be active

  @javascript
	Scenario: Should see limited information in card view
		Given I am on the admin dashboard
		And I click on the "square-proj-btn" button
		Then I should see "Client A project"
		And I should see "Client A"
		And I should see "short desc A"
		But I should not see "long desc A"

	Scenario: Clicking compact view should re-render compact/list view
		Given I am on the admin dashboard
		And I click on the "compact-proj-btn" button
		Then the "compact-proj-btn" button should be active
		And the "compact-proj-view" pane should be active
		And the "square-proj-btn" button should not be active
		And the "square-proj-view" pane should not be active
