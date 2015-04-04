# in features/sort_by_approve_deny.feature
Feature: Sort projects index by approved/pending/denied
	As an admin
	So that it is easier for me to match projects to students
	I want to view projects sorted by approved, pending, and denied.

  Background:
    Given I am logged in as an administrator
    And the following clients exist:
    | company_name | company_site       | company_address | contact_email       | contact_number |
    | Client A     | http://clienta.org | 123 Client A Dr | clienta@clienta.org | N/A            |

    And the following public projects exist:
    | title            | github_site                     | application_site | long_description | client   |
    | Client A project 1 | http://github.com/client-a-proj | N/A              | blahA            | Client A |
    | Client A project 2| http://github.com/client-a-proj | N/A              | blahB            | Client A |
    | Client A project 3| http://github.com/client-a-proj | N/A              | blahC            | Client A |

    Scenario: All start as "Pending"
    	Given I am on the admin dashboard
    	Then I should see "Pending" 3 times

    Scenario: "Approved" comes before "Pending"
        Given "Client A project 1" is approved
    	And I am on the admin dashboard
    	And I should see "Client A project 1" before "Client A project 1"

    Scenario: Denied comes after "Pending"
        Given "Client A project 3" is denied
    	And I am on the admin dashboard
    	And I should see "Client A project 2" before "Client A project 3"