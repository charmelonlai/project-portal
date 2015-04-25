Feature: Set dates for proposals
  As the portal admin
  So that I can close the portal after the deadline
  I want to set the deadline for accepting proposals on the admin dashboard

  Background:
    Given I am logged in as an administrator
    And I am on the admin dashboard

  Scenario: Close proposals
    Given the application is currently open (admin)
    When I set the proposal deadline to a past date
    Then I should see "Deadline successfully set to .*"
    And I should see "Set deadline for proposals \(currently .*\)"

  Scenario: Close proposals and login as client
    Given the application is currently open (admin)
    And I set the proposal deadline to a past date
    When I login as client "c"
    Then the link "Propose A Project" should have a not-allowed style and have no href attribute.

  Scenario: Open proposals
    Given the application is currently closed
    And I set the proposal deadline to a future date
    Then I should see "Deadline successfully set to .*"
    And I should see "Set deadline for proposals \(currently .*\)"

  Scenario: Open proposals and login as client
    Given the application is currently closed
    And I set the proposal deadline to a future date
    When I login as client "c"
    Then the link "Propose A Project" should link to the new projects page.
