Feature: Approve/decline client projects
  As an administrator
  So that I can successfully approve/decline a project
  I want a button on the "show" page of each project

  Background:
    Given I am logged in as an administrator
    And a project called "test-proj" exists, with short description "Multipurpose website"
    And I visit the "show" page for "test-proj"

  @javascript
  Scenario: Approve project
    Given "test-proj" is currently denied
    When I click "Approve"
    And I fill in "project[admin_note]" with "Like this project" within "#approval-form-popup-test-proj"
    And I press "Submit" within "#approval-form-popup-test-proj"
    Then I should be on the "show" page for "test-proj"
    And I should see "Project: 'test-proj' was successfully approved."
    And I should see "Project has been approved" within ".approval-buttons .details-title"
    And I should see a link "Decline" to "#denial-form-popup-test-proj"

  @javascript
  Scenario: Decline project
    Given "test-proj" is currently approved
    When I click "Decline"
    And I fill in "project[admin_note]" with "Don't like this project" within "#denial-form-popup-test-proj"
    And I press "Submit" within "#denial-form-popup-test-proj"
    Then I should be on the "show" page for "test-proj"
    And I should see "Project: 'test-proj' was successfully denied."
    And I should see "Project has been denied" within ".approval-buttons .details-title"
    And I should see a link "Approve" to "#approval-form-popup-test-proj"

  @javascript
  Scenario: Approve project and send notification email
    Given "test-proj" is currently denied
    When I click "Approve"
    And I fill in "project[admin_note]" with "Like this project" within "#approval-form-popup-test-proj"
    And I press "Submit" within "#approval-form-popup-test-proj"
    Then the client of "test-proj" should be sent a notification email about the approval

  @javascript
  Scenario: Decline project and send notification email
    Given "test-proj" is currently approved
    When I click "Decline"
    And I fill in "project[admin_note]" with "Don't like this project" within "#denial-form-popup-test-proj"
    And I press "Submit" within "#denial-form-popup-test-proj"
    Then the client of "test-proj" should be sent a notification email about the decline
