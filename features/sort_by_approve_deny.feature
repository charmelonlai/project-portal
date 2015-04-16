# in features/sort_by_approve_deny.feature
Feature: Sort projects index by approved/pending/denied
	As an admin
	So that it is easier for me to match projects to students
	I want to view projects sorted by approved, pending, and denied.

  Background:
    Given I am logged in as an administrator
    And the following clients exist:
    | company_name | company_site       | company_address | contact_email      | contact_number |
    | Client A     | http://clienta.org | 123 Client A Dr | client@clienta.org | N/A            |
    | Client B     | http://clientb.org | 123 Client B Dr | client@clientb.org | (408)-254-3682 |
    | Client C     | http://clientc.org | 123 Client C Dr | client@clientc.org | (408)-254-3683 |
    And the following projects exist:
    | title            | short_description | long_description | client   |
    | Client A project | short desc A      | long desc A      | Client A |
    | Client B project | short desc B      | long desc B      | Client B |
    | Client C project | short desc C      | long desc C      | Client C |

  Scenario: All start as "Pending"
    Given I am on the admin dashboard
    Then I should see "Pending" 3 times

  Scenario: "Approved" comes before "Pending"
    Given "Client A project" is approved
  	And I am on the admin dashboard
  	Then I should see "Client A project" before "Client B project"
    And I should see "Client A project" before "Client C project"

  Scenario: "Denied" comes after "Pending"
    Given "Client C project" is denied
    And I am on the admin dashboard
    Then I should see "Client A project" before "Client C project"
    And I should see "Client B project" before "Client C project"