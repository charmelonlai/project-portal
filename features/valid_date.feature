Feature: Set dates for proposals
  As the portal admin
  So that I can close the portal after the deadline
  I want to set the valid dates for accepting proposals on the admin dashboard

  Background:
    Given I am logged in as an administrator
    And I am on the admin-dashboard
    
  Scenario: Close Proposals
    Given the application is currently open
    When I set the proposal end date to a past date
    Then when I am logged in as a client
    Then I should not see 'Propose A Project'


  Scenario: Open Proposals
    Given the application is currently closed
    When I set the proposal end date to a future date
    Then when I am logged in as a client
    Then I should see 'Propose A Project'
