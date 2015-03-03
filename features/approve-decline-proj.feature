# in features/approve-decline-proj.feature
Feature: Approve/decline client projects
  As an administrator
  So that I can successfully approve/decline a project
  I want a button on the "show" page of each project

  Background:
    Given I am logged in as an administrator
    And a project called "test-proj" exists
    And I am on the "show" page for "test-proj"
  Scenario: Approve project
    Given the project is currently declined
    When I press "Approve"
    And I fill in "project[comment]" with "Like this project"
    Then I should be on the "show" page for "test-proj"
    And ".details-title" should include "Project has been approved"
    And I should see a button with "Decline"

  Scenario: Decline project
    Given the project is currently approved
    When I press "Decline"
    And I fill in "project[comment]" with "Don't like this project"
    Then I should be on the "show" page for "test-proj"
    And ".details-title" should include "Project has been declined"
    And I should see a button with "Approve"
  Scenario: Approve project and send notification email
    Given the project is currently declined
    When I press "Approve"
    And I fill in "project[comment]" with "Like this project"
    Then the client should receive a notification email about the approval # http://stackoverflow.com/a/15754349
  Scenario: Decline project and send notification email
    Given the project is currently approved
    When I press "Decline"
    And I fill in "project[comment]" with "Don't like this project"
    Then the client should receive a notification email about the decline # http://stackoverflow.com/a/15754349
