# in features/classify-proj.feature
Feature: Classify client projects
  As non-profit client
  So that I can find interested and invested developers
  I want to be able to classify my proposal by industry and project type


  Background:
    Given I am logged in as a client
    And I begin to create a project called "classify-proj" 
    And I am on the "create" page for the project

  Scenario: Classify project by industy
    Given the project is in the creation process
    When I press the "Industry" text field
    And I fill in "Industry" with "Big Data"
    And all other fields are filled in
    And I click the "submit" button
    Then I should have classified the correct industry for "classify-proj"

  Scenario: Classify project by type
    Given the project is in the creation process
    When I press the "Type" drop-down field
    And I choose "Development" from the drop-down field
    And all other fields are filled in
    And I click the "submit" button
    Then I should have classified the correct type for "classify-proj"