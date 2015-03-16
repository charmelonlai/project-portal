# in features/export-to-csv.feature
Feature: Export project info to CSV
  As the portal admin
  So that I can have project information in an easy-to-manipulate format
  I want to export a set of projects to a CSV file.

  Background:
    Given I am logged in as an administrator
    And the following clients exist:
    | company_name | company_site       | company_address | contact_email       | contact_number |
    | Client A     | http://clienta.org | 123 Client A Dr | clienta@clienta.org | N/A            |
    | Client B     | http://clientb.org | 123 Client B Dr | clienta@clientb.org | (408)-254-3682 |
    | Client C     | http://clientc.org | 123 Client C Dr | N/A                 | (408)-254-3683 |
    And the following projects exist:
    | title            | github_site                     | application_site | long_description | client   |
    | Client A project | http://github.com/client-a-proj | N/A              | blahA            | Client A |
    | Client B project | http://github.com/client-a-proj | N/A              | blahB            | Client B |
    | Client C project | http://github.com/client-a-proj | N/A              | blahC            | Client C |

  Scenario: Click "export to CSV" button
    Given I am on the "projects" page
    When I click "Export to CSV"
    Then I should be on the page "admin/projects/projects.csv"
    And I should see "title,client,contact_email,contact_number,github,app,long_description"
    And I should see "Client A project,Client A,clienta@clienta.org,N/A,http://github.com/client-a-proj,N/A,blahA"
    And I should see "Client B project,Client B,clientb@clienta.org,(408)-254-3682,http://github.com/client-b-proj,N/A,blahB"
    And I should see "Client C project,Client C,N/A,(408)-254-3683,http://github.com/client-c-proj,N/A,blahC"
