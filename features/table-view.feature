Feature: display project page view properly
	As an admin
	so that I can see the projects submitted
	I want to make sure that the projects are displayed properly

	Background: 
		Given I am loged in as an admin
		And I am on the projects page
	
	Scenario: should see card view by default, not full project view
		Given the default view is selected
		Then I should not see Client Website
		And I should not see Application URL
		And I should not see Project Purpose
		And I should see Project Name
		And I should see Project Owner
		And I should see Project Short Description

	Scenario: compact view should display properly when chosen
		Given the compact view is selected
		Then I should see Short Description
		And I should see Approval Status
		And I should not see Mission Statement
 
	Scenario: "more info" display should be shown when a project is hover overed
		When I hover over a project
		Then I should see Project Purpose
		And I should see Specifics


		
	
	
